import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static final Db _instance = Db._create();
  factory Db({bool inMemory = false}){
    _instance._inMemory = inMemory;
    return _instance;
  }
  
  Db._create();

  static Database? _database;
  bool _inMemory = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    if (_inMemory) {
      return openDatabase(inMemoryDatabasePath, version: 1, onCreate: _onCreate);
    }

    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'pets.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
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
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDbFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pets.db');
    await deleteDatabase(path);
    _database = null;
  }
}
