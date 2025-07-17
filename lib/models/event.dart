import 'package:projeto_estagio/utils/date_parser.dart';

import '../utils/injector.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = getIt.get<Uuid>();

class Event {
  String id;
  String type;
  String date;
  String? observation;
  String petId;
  late String updatedAt;

  Event({
    required this.type,
    required this.date,
    this.observation,
    required this.petId,
  }): id = uuid.v4()
  {
    updatedAt = DateParser.formatDateISO8601(DateTime.now());
  }

  Event._withId({
    required this.id,
    required this.type,
    required this.date,
    this.observation,
    required this.petId,
    required this.updatedAt
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    if(map.containsKey('id')){
      if(Uuid.isValidUUID(fromString: map['id'])){
        return Event._withId(
          id: map['id'], 
          type: map['type'],
          date: map['date'],
          observation: map['observation'],
          petId: map['animal_id'],
          updatedAt: map["updated_at"]
        );
      }
    }
    
    return Event(
      type: map['type'],
      date: map['date'],
      observation: map['observation'],
      petId: map['animal_id'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String,dynamic> map = {
      "id":id,
      "type": type,
      "date": date,
      "animal_id": petId,
      'updated_at':updatedAt
    };

    if(observation != null) map['observation'] = observation;

    return map;
  }

  @override
  String toString() {
    return 'Event {id: $id, type: $type, date: $date, observation: ${observation ?? 'was not provided'}, petId: $petId}';
  }
}
