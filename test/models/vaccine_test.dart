import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_estagio/models/vaccine.dart';
void main() {
  group('Vaccine Model', () {
    test('Should convert valid date strings to DateTime objects', () {
      final vaccine = Vaccine(
        id: 1,
        name: 'Rabies',
        dateApplication: '10/07/2025',
        nextDateApplication: '10/07/2026',
        petId: 2,
      );

      expect(vaccine.dateApplicationDateTime, DateTime(2025, 7, 10));
      expect(vaccine.nextDateApplicationDateTime, DateTime(2026, 7, 10));
    });

    test('Should return null for invalid date strings', () {
      final vaccine = Vaccine(
        id: 2,
        name: 'V8',
        dateApplication: '99/99/9999',
        nextDateApplication: 'abc/def/ghi',
        petId: 3,
      );

      expect(vaccine.dateApplicationDateTime, isNull);
      expect(vaccine.nextDateApplicationDateTime, isNull);
    });

    test('Should update string fields when setting DateTime properties', () {
      final vaccine = Vaccine(
        id: 3,
        name: 'V10',
        dateApplication: '01/01/2020',
        nextDateApplication: '01/01/2021',
        petId: 4,
      );

      vaccine.dateApplicationDateTime = DateTime(2030, 12, 25);
      vaccine.nextDateApplicationDateTime = DateTime(2031, 1, 1);

      expect(vaccine.dateApplication, '25/12/2030');
      expect(vaccine.nextDateApplication, '01/01/2031');
    });

    test('Should correctly convert from and to Map', () {
      final map = {
        'id': 10,
        'name': 'Canine Flu',
        'dateApplication': '05/06/2025',
        'nextDateApplication': '05/06/2026',
        'petId': 99,
      };

      final vaccine = Vaccine.fromMap(map);
      expect(vaccine.id, 10);
      expect(vaccine.name, 'Canine Flu');
      expect(vaccine.dateApplication, '05/06/2025');
      expect(vaccine.nextDateApplication, '05/06/2026');
      expect(vaccine.petId, 99);

      final newMap = vaccine.toMap();
      expect(newMap, map);
    });

    test('Should return correct string representation', () {
      final vaccine = Vaccine(
        id: 5,
        name: 'Rabies',
        dateApplication: '01/02/2022',
        nextDateApplication: '01/02/2023',
        petId: 10,
      );

      final expected = 'Vaccine {id: 5, name: Rabies, dateApplication: 01/02/2022, nextDateApplication: 01/02/2023, petId: 10}';
      expect(vaccine.toString(), expected);
    });
  });
}
