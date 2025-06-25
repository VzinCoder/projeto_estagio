import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projeto_estagio/utils/db.dart';
import '../helpers_from_test/initFfiDb.dart';

void main() {
  initFfiDb();

  group('Db in-memory tests', () {
    late Db testDb;
    late Database db;

    setUp(() async {
      testDb = Db(inMemory: true); // nova instância em memória
      db = await testDb.database;
    });

    tearDown(() async {
      await testDb.close();
    });

    test('must create the database and check if the tables exist', () async {
      final List<Map<String, Object?>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table';",
      );

      expect(tables.any((t) => t['name'] == 'animals'), isTrue);
      expect(tables.any((t) => t['name'] == 'vaccines'), isTrue);
      expect(tables.any((t) => t['name'] == 'events'), isTrue);
    });

    test('should insert an animal and retrieve it correctly', () async {
      final int id = await db.insert('animals', {
        'name': 'Luna',
        'type': 'Cat',
        'breed': 'Siamese',
        'date_of_birth': '2022-01-01',
      });

      expect(id, greaterThan(0));

      final result = await db.query('animals', where: 'id = ?', whereArgs: [id]);
      expect(result.length, 1);
      final animal = result.first;

      expect(animal['name'], 'Luna');
      expect(animal['type'], 'Cat');
      expect(animal['breed'], 'Siamese');
      expect(animal['date_of_birth'], '2022-01-01');
    });

    test('each in-memory instance should be isolated', () async {
      // cria e insere em outro banco em memória
      final db2 = await Db(inMemory: true).database;
      final result = await db2.query('animals');
      expect(result, isEmpty);
      await db2.close();
    });

    test('close() should clear the internal db reference', () async {
      await testDb.close();
      final reopened = await testDb.database;
      expect(reopened.isOpen, isTrue);
    });
  });

  group('Db persistent (disk) tests', () {
    setUp(() async {
      await Db().deleteDbFile(); // limpa o arquivo físico
    });

    tearDown(() async {
      await Db().close();
    });

    test('should persist data across connections', () async {
      final db1 = await Db().database;

      final id = await db1.insert('animals', {
        'name': 'Bolt',
        'type': 'Dog',
        'breed': 'Beagle',
        'date_of_birth': '2021-01-01',
      });

      await Db().close(); // fecha o banco

      final db2 = await Db().database; // reabre
      final result = await db2.query('animals', where: 'id = ?', whereArgs: [id]);
      expect(result.length, 1);
      expect(result.first['name'], 'Bolt');
    });

    test('deleteDbFile should remove physical database file', () async {
      final db = await Db().database;
      await db.insert('animals', {
        'name': 'DeleteMe',
        'type': 'Dog',
        'breed': 'Mix',
        'date_of_birth': '2020-01-01',
      });

      await Db().deleteDbFile(); // apaga arquivo
      final db2 = await Db().database;

      final result = await db2.query('animals');
      expect(result, isEmpty); // sem dados após exclusão
    });

    test('singleton returns the same instance', () async {
      final db1 = await Db().database;
      final db2 = await Db().database;
      expect(identical(db1, db2), isTrue);
    });
  });
}
