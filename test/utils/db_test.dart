import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:projeto_estagio/utils/db.dart';

void initFfiDb() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfiNoIsolate;
}
void main(){
 initFfiDb();

  setUp(() async{
    await Db().deleteDbFile();
  });

  tearDown(() async{
    await Db().close();
  });

  test('must create the database and check if the tables exist',() async {
      final Database db  = await Db().database;

      final List<Map<String,Object?>> tables = await db.rawQuery("SELECT name from sqlite_master WHERE type='table'");
      
      expect(tables.any((row) => row['name'] == 'animals'), true);
      expect(tables.any((row) => row['name'] == 'vaccines'), true);
      expect(tables.any((row) => row['name'] == 'events'), true);
  });

  test('you must insert an animal and check if it was saved',() async {
    final Database db = await Db().database;
    int id = await db.insert('animals', {
      'name':'bread',
      'type':'dog',
      'breed':'german',
      'date_of_birth':'2025-05-3'
    });
    
    expect(id, isNonZero);
    final result = await db.query('animals', where: 'id = ?', whereArgs: [id]);

    // Verifica os dados
    expect(result.length, 1);
    final animal = result.first;
    expect(animal['name'], 'bread');
    expect(animal['type'], 'dog');
    expect(animal['breed'], 'german');
    expect(animal['date_of_birth'], '2025-05-3');
  });

}