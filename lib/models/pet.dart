import "../utils/injector.dart";
import 'package:uuid/uuid.dart';
import '../utils/date_parser.dart';

Uuid uuid = getIt.get<Uuid>();

class Pet {
  String id;
  String name;
  String type;
  String breed;
  String dateOfBirth;
  late String updatedAt;

  Pet({
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
  }): id = uuid.v4()
  {
    updatedAt = DateParser.formatDate(DateTime.now());
  }

  // se é necessário instanciar um pet com id então significa que ele já tem um updated_at.
  Pet._withId({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
    required this.updatedAt
  });

  DateTime? get dateOfBirthDateTime => DateParser.parseDate(dateOfBirth);

  set dateOfBirthDateTime (DateTime? date){
    if(date != null){
      dateOfBirth = DateParser.formatDate(date);
    }
  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'date_of_birth': dateOfBirth,
      'updated_at':updatedAt
    };
    return map;
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    if(map.containsKey('id')){
      if(Uuid.isValidUUID(fromString: map['id'])){
        return Pet._withId(
          id: map['id'], 
          name: map['name'], 
          type: map['type'], 
          breed: map['breed'], 
          dateOfBirth: map['date_of_birth'],
          updatedAt: map['updated_at']
        );
      }
    }

    return Pet(
      name: map['name'],
      type: map['type'],
      breed: map['breed'],
      dateOfBirth: map['date_of_birth'],
    );
  }

  @override
  String toString() {
    return 'Pet {id: $id, name: $name, type: $type, breed: $breed, dateOfBirth: $dateOfBirth}';
  }

}