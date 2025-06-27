import "package:projeto_estagio/models/vaccine.dart";
import "package:sqflite/sqflite.dart";
import "i_vaccine_repository.dart";

class VaccineRepository implements IVaccineRepository{
  final Database db;
  final String table = "vaccines";
  VaccineRepository({required this.db});


  @override
  Future<int> insertVaccine(Vaccine vaccine) async {
    return await db.insert(table, vaccine.toMap());
  }

  @override
  Future<int> deleteVaccine(int id) async {
    return await db.delete(
      table, 
      where: "id = ?",
      whereArgs: [id]
    );
  }

  @override
  Future<List<Vaccine>> getAllVaccines() async {
    List<Map<String, Object?>> result = await db.rawQuery("SELECT * FROM vaccines");
    return result.map((vaccineMap)=> Vaccine.fromMap(vaccineMap)).toList();
  }

  @override
  Future<Vaccine?> getVaccineById(int id) async {
    var result = await db.query(table, where: 'id = ?', whereArgs: [id]);

    if(result.isEmpty) return null;

    return Vaccine.fromMap(result.first);
  }

  @override
  Future<List<Vaccine>> getVaccinesByPetId(int petId) async {
    var result = await db.query(table, where: 'animal_id = ?', whereArgs: [petId]);

    return result.map((vaccineMap)=> Vaccine.fromMap(vaccineMap)).toList();
  }
  @override
  Future<int> updateVaccine(Vaccine vaccine) {
    if (vaccine.id == null) {
      throw Exception("Cannot update vaccine without ID");
    }

    return db.update(
      table, 
      vaccine.toMap(),
      where: "id = ?",
      whereArgs: [vaccine.id]
    );
  }
}