import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_estagio/utils/db.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import '../helpers_from_test/initFfiDb.dart';

void main() {
  initFfiDb();
  late PetRepository repository;

  setUp(() async {
    final db = await Db(inMemory: true).database;
    repository = PetRepository(db);
  });

  test('insertPet should return generated ID', () async {
    final pet = Pet(
      name: 'Luna',
      type: 'Cat',
      breed: 'Siamese',
      dateOfBirth: '2021-01-01',
    );

    final id = await repository.insertPet(pet);
    expect(id, greaterThan(0));
  });

  test('getAllPets should return all inserted pets', () async {
    await repository.insertPet(Pet(
      name: 'Bolt',
      type: 'Dog',
      breed: 'Beagle',
      dateOfBirth: '2022-02-02',
    ));

    final pets = await repository.getAllPets();
    expect(pets.length, 1);
    expect(pets.first.name, 'Bolt');
  });

  test('getPetById should return the correct pet', () async {
    final id = await repository.insertPet(Pet(
      name: 'Max',
      type: 'Dog',
      breed: 'Poodle',
      dateOfBirth: '2020-03-03',
    ));

    final pet = await repository.getPetById(id);
    expect(pet, isNotNull);
    expect(pet!.name, 'Max');
  });

  test('getPetById should return null when pet not found', () async {
    final pet = await repository.getPetById(9999);
    expect(pet, isNull);
  });

  test('updatePet should update an existing pet', () async {
    final id = await repository.insertPet(Pet(
      name: 'Rex',
      type: 'Dog',
      breed: 'Labrador',
      dateOfBirth: '2019-04-04',
    ));

    final updatedPet = Pet(
      id: id,
      name: 'Rex Jr.',
      type: 'Dog',
      breed: 'Labrador',
      dateOfBirth: '2019-04-04',
    );

    final rowsAffected = await repository.updatePet(updatedPet);
    expect(rowsAffected, 1);

    final fetched = await repository.getPetById(id);
    expect(fetched!.name, 'Rex Jr.');
  });

  test('updatePet should throw exception if pet ID is null', () async {
    final pet = Pet(
      name: 'Nameless',
      type: 'Unknown',
      breed: 'Unknown',
      dateOfBirth: '2000-01-01',
    );

    expect(() => repository.updatePet(pet), throwsException);
  });

  test('deletePet should delete a pet', () async {
    final id = await repository.insertPet(Pet(
      name: 'Ghost',
      type: 'Dog',
      breed: 'Husky',
      dateOfBirth: '2018-05-05',
    ));

    final deletedRows = await repository.deletePet(id);
    expect(deletedRows, 1);

    final pet = await repository.getPetById(id);
    expect(pet, isNull);
  });
}
