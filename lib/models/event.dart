import '../utils/injector.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = getIt.get<Uuid>();

class Event {
  String id;
  String type;
  String date;
  String observation;
  String petId;

  Event({
    required this.type,
    required this.date,
    required this.observation,
    required this.petId,
  }): id = uuid.v4();

  Event._withId({
    required this.id,
    required this.type,
    required this.date,
    required this.observation,
    required this.petId,
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
    return {
      "id":id,
      "type": type,
      "date": date,
      "observation": observation,
      "animal_id": petId,
    };
  }

  @override
  String toString() {
    return 'Event {id: $id, type: $type, date: $date, observation: $observation, petId: $petId}';
  }
}
