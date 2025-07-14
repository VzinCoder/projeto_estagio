import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_estagio/repositories/event_repository.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/date_parser.dart';
import './pet_repository.dart';
import '../services/api_services.dart';
import '../models/pet.dart';
import '../models/vaccine.dart';
import '../models/event.dart';

class ApiRepository {
  PetRepository petRepository;
  VaccineRepository vaccineRepository;
  EventRepository eventRepository;
  DioClient dioClient;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  final String inicialDate = '0001-01-01T01:01:01Z';

  ApiRepository({
    required this.petRepository,
    required this.vaccineRepository,
    required this.eventRepository,
    required this.dioClient
  });

  Future<String> _getLastUploadDate()async{

    if(!await storage.containsKey(key:'last_upload_at')){
      await storage.write(key: 'last_upload_at', value: inicialDate);
    }
    
    String? date = await storage.read(key: 'last_upload_at');
    return date!;
  }

  Future<String> get lastUploadDate async => _getLastUploadDate();

  set lastUploadDateSetter(String date){
    storage.write(key: 'last_upload_at', value: date);
  }

  Future<String> _getLastDownloadDate()async{

    if(!await storage.containsKey(key:'last_download_at')){
      await storage.write(key: 'last_download_at', value: inicialDate);
    }
    
    String? date = await storage.read(key: 'last_download_at');
    return date!;
  }

  Future<String> get lastDownloadDate=> _getLastDownloadDate();

  set lastDownloadDateSetter(String date){
    storage.write(key: 'last_download_at', value: date);
  }
  

  Future checkDownloadUpdates()async{
    final String endPoint = '/api/sync/check-update';

    String lastDownDate = await lastDownloadDate;
    String lastUpDate = await lastUploadDate;

    // os dados para download devem satisfazer a condição de que foram atualizados depois do último download e upload
    // como na api só é possível enviar apenas uma data, então deve ser enviada a maior delas.
    bool syncDateIsAfter = DateParser.isAfterDate(lastDownDate, lastUpDate);

    String recentDate = syncDateIsAfter ? lastDownDate : lastUpDate;

    final response = await dioClient.sendPostRequest(
      endPoint: endPoint,
      map: {
        'last_synced_at':recentDate
      }
    );

    if(response is Map){
      if(response.containsKey('data')){
        return response['data'];
      }
    }else{
      return response;
    }
  }

  Future<bool> _wasUpdated(String updatedAt)async{
    String downloadDate = await lastDownloadDate;
    String uploadDate = await lastUploadDate;
    bool isAfterLastDowload = DateParser.isAfterDate(updatedAt, downloadDate);
    bool isAfterLastUpload = DateParser.isAfterDate(updatedAt, uploadDate);

    return isAfterLastUpload && isAfterLastDowload;
  }

  Future<Map<String, List>> _elementsUpdated(
    {
      required List<Pet> allPets,
      required List<Vaccine> allVaccines,
      required List<Event> allEvents,
    }
  ) async {
    List<dynamic> allElementsList = [allPets, allVaccines, allEvents];

    List<Pet> petsUpdated = [];
    List<Vaccine> vaccinesUpdated = [];
    List<Event> eventsUpdated= [];

    for (var elementsListType in allElementsList) {
      for (var element in elementsListType) {
        bool isUpdated = await _wasUpdated(element.updatedAt);
        if(isUpdated){
          switch (element.runtimeType.toString()) {
            case 'Pet':
              petsUpdated.add(element);
              break;
            case 'Vaccine':
              vaccinesUpdated.add(element);
              break;
            case 'Event':
              eventsUpdated.add(element);
          }
        }
      }
    }

    return {
      'pets_updated':petsUpdated,
      'vaccines_updated':vaccinesUpdated,
      'events_updated': eventsUpdated
    };
  }

  Future<Map<String,dynamic>> checkUploadUpdates()async{
    List<Pet> allPets = await petRepository.getAllPets();
    List<Vaccine> allVaccines = await vaccineRepository.getAllVaccines();
    List<Event> allEvents = await eventRepository.getAllEvents();

    final elementsUpdatedMap = await _elementsUpdated(
      allPets: allPets, 
      allVaccines: allVaccines, 
      allEvents: allEvents, 
    );
    int numPetsUpdates = elementsUpdatedMap['pets_updated']!.length;
    int numVaccinesUpdates = elementsUpdatedMap['vaccines_updated']!.length;
    int numEventsUpdates = elementsUpdatedMap['events_updated']!.length;
    bool hasUpdates = numPetsUpdates != 0 || numVaccinesUpdates != 0 || numEventsUpdates != 0;
    
    return {
      'has_updates': hasUpdates,
      'update_counts':{
        'animals': numPetsUpdates,
        'vaccines': numVaccinesUpdates,
        'events': numEventsUpdates, 
      }
    };
  }

  Future<Map<String, dynamic>> _structureData(
    {
      required List<Pet> petsUpdated,
      required List<Vaccine> vaccinesUpdated,
      required List<Event> eventsUpdated,
    }
  ) async {
    // estrutura que facilita o acesso aos pets pelo id e assim alocar suas respectivas vacina e eventos
    Map<String, dynamic> petsMap = {};

    for (var pet in petsUpdated) {
      petsMap[pet.id] = pet.toMap();
      petsMap[pet.id]['vaccines'] = [];
      petsMap[pet.id]['events'] = [];
    }

    // estruturando as vacinas dentro de seus respectivos pets
    for (var vaccine in vaccinesUpdated) {
      var petMap = petsMap[vaccine.petId];
      if(petMap != null){
        petMap['vaccines'].add(vaccine.toMap());
        petsMap[vaccine.petId] = petMap;
        continue;
      }
      Pet? pet = await petRepository.getPetById(vaccine.petId);

      petsMap[vaccine.petId] = pet!.toMap();
      petsMap[vaccine.petId]['vaccines'] = [vaccine.toMap()];
      petsMap[vaccine.petId]['events'] = [];
    }

    // estruturando os eventos dentro de seus respectivos pets
    for (var event in eventsUpdated) {
      var petMap = petsMap[event.petId];
      if(petMap != null){
        petMap['events'].add(event.toMap());
        petsMap[event.petId] = petMap;
        continue;
      }

      Pet? pet = await petRepository.getPetById(event.petId);

      petsMap[event.petId] = pet!.toMap();
      petsMap[event.petId]['events'] = [event.toMap()];
      petsMap[event.petId]['vaccines'] = [];
    }

    return {'pets': petsMap.values.toList()};
  }

  Future uploadData()async{
    String endPoint = '/api/sync/upload';

    List<Pet> allPets = await petRepository.getAllPets();
    List<Vaccine> allVaccines = await vaccineRepository.getAllVaccines();
    List<Event> allEvents = await eventRepository.getAllEvents();

    final elementsUpdatedMap = await _elementsUpdated(
      allPets: allPets, 
      allVaccines: allVaccines, 
      allEvents: allEvents,
    );

    final uploadData = await _structureData(
      petsUpdated: elementsUpdatedMap['pets_updated'] as List<Pet>, 
      vaccinesUpdated: elementsUpdatedMap['vaccines_updated'] as List<Vaccine>, 
      eventsUpdated: elementsUpdatedMap['events_updated'] as List<Event>
    );
    
    final response = await dioClient.sendPostRequest(
      endPoint: endPoint, 
      map: uploadData
    );

    if(response['statusCode'] == 200) lastUploadDateSetter = DateParser.formatDateISO8601(DateTime.now());
    
    return response;
    // print("dados que vão ser enviados para a api: $uploadData");
  }


  Future downloadData()async{
    final String endPoint = '/api/sync/download';

    String lastDownDate = await lastDownloadDate;
    String lastUpDate = await lastUploadDate;

    // os dados para download devem satisfazer a condição de que foram atualizados depois do último download e upload
    // como na api só é possível enviar apenas uma data, então deve ser enviada a maior delas.
    bool syncDateIsAfter = DateParser.isAfterDate(lastDownDate, lastUpDate);

    String recentDate = syncDateIsAfter ? lastDownDate : lastUpDate;

    final response = await dioClient.sendPostRequest(
      endPoint: endPoint, 
      map: {
        'last_synced_at': recentDate
      }
    );

    if(response is! Map) return response;

    final Map<String, dynamic> data = response['data'];

    
    if(data['pets'] is List){
      if(data['pets'].isEmpty) return;
      await _loadPetsToDb(data['pets']);
    }

    lastDownloadDateSetter = data['synced_at'];
  }

  Future _loadPetsToDb(List<dynamic> petMapList)async{
    final List<Pet> allPetsFromDb = await petRepository.getAllPets();

    for (var petData in petMapList) {
      if(petData is! Map<String,dynamic>) continue;

      final petMap = {
        'id': petData['id'],
        'name': petData['name'],
        'type': petData['type'],
        'breed': petData['breed'],
        'date_of_birth': petData['date_of_birth'],
        'updated_at':petData['updated_at']
      };

      if(!petData['vaccines'].isEmpty){
        _loadVaccinesToDb(petData['vaccines']);
      }
      if(!petData['events'].isEmpty){
        _loadEventsToDb(petData['events']);
      }

      Pet pet = Pet.fromMap(petMap);

      Pet? petFoundFromDb; 
      allPetsFromDb.map(
        (pet){
          if(pet.id == petData['id']) petFoundFromDb = pet;
        } 
      );

      if(petFoundFromDb != null){
        petRepository.updatePet(
          pet,
          remainUpdatedAt: true
        );
      }else{
        petRepository.insertPet(pet);
      }
    }
  }

  Future _loadVaccinesToDb(List<dynamic> vaccineMapList)async{
    final List<Vaccine> allVaccinesFromDb = await vaccineRepository.getAllVaccines();

    for (var vaccineData in vaccineMapList) {
      if(vaccineData is! Map<String,dynamic>) continue;

      final vaccineMap = {
        "id": vaccineData['id'],
        "updated_at": vaccineData['updated_at'],
        "name": vaccineData['name'],
        "application_date": vaccineData['application_date'],
        "next_dose_date": vaccineData['next_dose_date'],
        "animal_id": vaccineData['animal']
      };

      Vaccine vaccine = Vaccine.fromMap(vaccineMap);

      Vaccine? vaccineFoundFromDb; 
      allVaccinesFromDb.map(
        (vaccine){
          if(vaccine.id == vaccineData['id']) vaccineFoundFromDb = vaccine;
        } 
      );

      if(vaccineFoundFromDb != null){
        vaccineRepository.updateVaccine(
          vaccine,
          remainUpdatedAt: true
        );
      }else{
        vaccineRepository.insertVaccine(vaccine);
      }
    }
  }

  Future _loadEventsToDb(List<dynamic> eventMapList)async{
    final List<Event> allEventsFromDb = await eventRepository.getAllEvents();

    for (var eventData in eventMapList) {
      if(eventData is! Map<String,dynamic>) continue;

      final eventMap = {
        "id": eventData['id'],
        "updated_at": eventData['updated_at'],
        "type": eventData['type'],
        "date": eventData['date'],
        "observation": eventData['observation'],
        "animal_id": eventData['animal']
      };

      Event event = Event.fromMap(eventMap);

      Event? eventFoundFromDb; 
      allEventsFromDb.map(
        (event){
          if(event.id == eventData['id']) eventFoundFromDb = event;
        } 
      );

      if(eventFoundFromDb != null){
        eventRepository.updateEvent(
          event,
          remainUpdatedAt: true
        );
      }else{
        eventRepository.insertEvent(event);
      }
    }
  }
}