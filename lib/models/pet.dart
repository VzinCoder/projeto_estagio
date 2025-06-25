


class Pet {
  int? id;
  String name;
  String type;
  String breed;
  String dateOfBirth;

  Pet({
    this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
  });

  Map<String,dynamic> toMap(){
    Map<String, dynamic> map = {
      'name': name,
      'type': type,
      'breed': breed,
      'date_of_birth': dateOfBirth,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
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