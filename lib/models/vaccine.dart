import 'package:projeto_estagio/utils/date_parser.dart';

import '../utils/injector.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = getIt.get<Uuid>();

class Vaccine {
  String id;
  String name;
  String dateApplication;
  String? nextDateApplication;
  String petId;
  late String updatedAt;

  Vaccine({
    required this.name,
    required this.dateApplication,
    this.nextDateApplication,
    required this.petId,
  }): id = uuid.v4()
  {
    updatedAt = DateParser.formatDateISO8601(DateTime.now());
  }

  // se uma vacina já tem id é pq o campo update_at já foi inicializado.
  Vaccine._withId({
    required this.id,
    required this.name,
    required this.dateApplication,
    this.nextDateApplication,
    required this.petId,
    required this.updatedAt
  });

  DateTime? get dateApplicationDateTime => DateParser.parseDate(dateApplication);
  DateTime? get nextDateApplicationDateTime{
    if(nextDateApplication != null) return DateParser.parseDate(nextDateApplication!);

    return null;
  } 

  set dateApplicationDateTime(DateTime? date) {
    if (date != null) {
      dateApplication = DateParser.formatDate(date);
    }
  }

  set nextDateApplicationDateTime(DateTime? date) {
    if (date != null) {
      nextDateApplication = DateParser.formatDate(date);
    }
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    if(map.containsKey('id')){
      if(Uuid.isValidUUID(fromString: map['id'])){
        return Vaccine._withId(
          id: map['id'],
          name: map['name'],
          dateApplication: map['application_date'],
          nextDateApplication: map['next_dose_date'],
          petId: map['animal_id'],
          updatedAt: map['updated_at']
        );
      }
    }

    return Vaccine(
      name: map['name'],
      dateApplication: map['application_date'],
      nextDateApplication: map['next_dose_date'],
      petId: map['animal_id'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'application_date': dateApplication,
      'animal_id': petId,
      'updated_at':updatedAt
    };

    if(nextDateApplication != null) map['next_dose_date'] = nextDateApplication;
    
    return map;
  }

  @override
  String toString() {
    return 'Vaccine {id: $id, name: $name, dateApplication: $dateApplication, nextDateApplication: ${nextDateApplication ?? 'was not provided'}, petId: $petId}';
  }
}
