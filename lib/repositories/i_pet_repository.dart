import 'package:projeto_estagio/models/pet.dart';

abstract class IPetRepository {
  Future<int> insertPet(Pet pet);
  Future<List<Pet>> getAllPets();
  Future<Pet?> getPetById(String id);
  Future<int> updatePet(Pet pet);
  Future<int> deletePet(String id);
}