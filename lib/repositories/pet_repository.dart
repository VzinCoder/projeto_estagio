import 'package:sqflite/sqflite.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/repositories/i_pet_repository.dart';

class PetRepository implements IPetRepository{
  final Database db;

  PetRepository(this.db);

  @override
  Future<int> deletePet (String id)  {
    return db.delete('animals',where:'id = ?',whereArgs: [id]);
  }

  @override
  Future<List<Pet>> getAllPets() async {
    final result = await db.query('animals');
    return result.map((map) => Pet.fromMap(map)).toList();
  }

  @override
  Future<Pet?> getPetById(String id) async {
    final result = await db.query('animals', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Pet.fromMap(result.first);
  }

  @override
  Future<int> insertPet(Pet pet) {
    return db.insert('animals', pet.toMap());
  }

  @override
  Future<int> updatePet(Pet pet) {
    // É impossivel um pet não ter id.
    // if (pet.id == null) {
    //   throw Exception("Cannot update pet without ID");
    // }
    return db.update('animals', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

}