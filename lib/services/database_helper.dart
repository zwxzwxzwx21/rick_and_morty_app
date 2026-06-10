import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/character.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('characters.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE characters (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  status TEXT NOT NULL,
  species TEXT NOT NULL,
  type TEXT NOT NULL,
  gender TEXT NOT NULL,
  image TEXT NOT NULL,
  origin TEXT NOT NULL,
  location TEXT NOT NULL
)
''');
    await db.execute('''
CREATE TABLE favorites (
  id INTEGER PRIMARY KEY
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
CREATE TABLE favorites (
  id INTEGER PRIMARY KEY
)
''');
    }
  }

  Future<void> insertCharacters(List<Character> characters) async {
    final db = await instance.database;
    final batch = db.batch();
    for (var character in characters) {
      batch.insert(
        'characters',
        character.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Character>> getAllCharacters() async {
    final db = await instance.database;
    final result = await db.query('characters');
    return result.map((json) => Character.fromMap(json)).toList();
  }

  Future<void> deleteAllCharacters() async {
    final db = await instance.database;
    await db.delete('characters');
  }

  Future<void> addFavorite(int id) async {
    final db = await instance.database;
    await db.insert('favorites', {'id': id}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<int>> getFavoriteIds() async {
    final db = await instance.database;
    final result = await db.query('favorites');
    return result.map((row) => row['id'] as int).toList();
  }
}
