import 'package:sqflite/sqflite.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/repositories/i_pet_repository.dart';
import '../utils/date_parser.dart';

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

  // se o pet acabou de ser criado então o updated_at já foi inicializado.
  @override
  Future<int> insertPet(Pet pet) {
    return db.insert('animals', pet.toMap());
  }

  @override
  Future<int> updatePet(
    Pet pet,
    {
      remainUpdatedAt = false
    }
  ) {
    // É impossivel um pet não ter id.
    // if (pet.id == null) {
    //   throw Exception("Cannot update pet without ID");
    // }

    if(!remainUpdatedAt) pet.updatedAt = DateParser.formatDateISO8601(DateTime.now());
    
    return db.update('animals', pet.toMap(), where: 'id = ?', whereArgs: [pet.id]);
  }

}