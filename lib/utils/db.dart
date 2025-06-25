import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static Database? _persistentDb;
  static Db? _singletonInstance;

  final bool _inMemory;
  Database? _inMemoryDb;

  factory Db({bool inMemory = false}) {
    if (inMemory) {
      return Db._internal(inMemory: true); 
    }
    _singletonInstance ??= Db._internal();
    return _singletonInstance!;
  }

  Db._internal({bool inMemory = false}) : _inMemory = inMemory;

  Future<Database> get database async {
    if (_inMemory) {
      _inMemoryDb ??= await _initDb();
      return _inMemoryDb!;
    }

    _persistentDb ??= await _initDb();
    return _persistentDb!;
  }

  Future<Database> _initDb() async {
    if (_inMemory) {
      return openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: _onCreate,
        singleInstance: false,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pets.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE animals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        breed TEXT NOT NULL,
        date_of_birth TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE vaccines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animal_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        application_date TEXT NOT NULL,
        next_dose_date TEXT,
        FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        animal_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        observation TEXT,
        FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> close() async {
    if (_inMemory) {
      await _inMemoryDb?.close();
      _inMemoryDb = null;
    } else {
      await _persistentDb?.close();
      _persistentDb = null;
    }
  }

  Future<void> deleteDbFile() async {
    if (_inMemory) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pets.db');
    await deleteDatabase(path);
    _persistentDb = null;
  }
}
