import "../utils/injector.dart";
import 'package:uuid/uuid.dart';

Uuid uuid = getIt.get<Uuid>();

class Pet {
  String id;
  String name;
  String type;
  String breed;
  String dateOfBirth;

  Pet({
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
  }): id = uuid.v4();

  Pet._withId({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
  });

  DateTime? get dateOfBirthDateTime => _parseDate(dateOfBirth);

  set dateOfBirthDateTime (DateTime? date){
    if(date != null){
      dateOfBirth = _formatDate(date);
    }
  }

  DateTime? _parseDate(String dateString){
    if(!_isValidFormat(dateString)) return null;

    try {
      final parts = dateString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  bool _isValidFormat(String dateString){
    var dateStringParts = dateString.split("/");
    if(dateStringParts.length != 3) return false;

    var dateParts = dateStringParts.map((part)=> int.tryParse(part)).toList();

    int? day = dateParts[0];
    int? month = dateParts[1];
    int? year = dateParts[2];

    try{
      var date = DateTime(year!, month!, day!);
      return date.day == day && date.month == month && date.year == year;
    }catch(_){
      return false;
    }
  }

  String _formatDate(DateTime date){
    String day = date.day.toString().padLeft(2,"0");
    String month = date.month.toString().padLeft(2,"0");
    String year = date.year.toString();

    return "$day/$month/$year";
  }

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'date_of_birth': dateOfBirth,
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
          dateOfBirth: map['date_of_birth']
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