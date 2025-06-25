import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_estagio/models/pet.dart';

void main() {
  group('Pet model', () {
    test('toMap() should convert Pet object to a Map', () {
      final pet = Pet(
        id: 1,
        name: 'Milo',
        type: 'Cat',
        breed: 'Siamese',
        dateOfBirth: '2022-01-10',
      );

      final map = pet.toMap();

      expect(map['id'], 1);
      expect(map['name'], 'Milo');
      expect(map['type'], 'Cat');
      expect(map['breed'], 'Siamese');
      expect(map['date_of_birth'], '2022-01-10');
    });

    test('fromMap() should create a Pet object from a Map', () {
      final map = {
        'id': 2,
        'name': 'Bella',
        'type': 'Dog',
        'breed': 'Poodle',
        'date_of_birth': '2021-07-05',
      };

      final pet = Pet.fromMap(map);

      expect(pet.id, 2);
      expect(pet.name, 'Bella');
      expect(pet.type, 'Dog');
      expect(pet.breed, 'Poodle');
      expect(pet.dateOfBirth, '2021-07-05');
    });

    test('toString() should return the correct string representation', () {
      final pet = Pet(
        id: 3,
        name: 'Rex',
        type: 'Dog',
        breed: 'Labrador',
        dateOfBirth: '2020-05-01',
      );

      final str = pet.toString();

      expect(
        str,
        'Pet {id: 3, name: Rex, type: Dog, breed: Labrador, dateOfBirth: 2020-05-01}',
      );
    });
  });
}
