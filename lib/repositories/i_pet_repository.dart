import 'package:projeto_estagio/models/pet.dart';

abstract class IPetRepository {
  Future<int> insertPet(Pet pet);
  Future<List<Pet>> getAllPets();
  Future<Pet?> getPetById(int id);
  Future<int> updatePet(Pet pet);
  Future<int> deletePet(int id);
}