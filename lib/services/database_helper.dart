import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'favorites.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            title TEXT,
            authors TEXT,
            image TEXT
          )
          ''',
        );
      },
    );
  }

  Future<int> addFavorite(Map<String, dynamic> book) async {
    final db = await database;
    return db.insert('favorites', book, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return db.query('favorites');
  }

  Future<int> removeFavorite(String id) async {
    final db = await database;
    return db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
