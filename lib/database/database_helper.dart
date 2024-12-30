import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/song_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favourites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favourites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        number TEXT,
        markdown TEXT,
        isFavorite BOOLEAN
      )
    ''');
  }

  // Check if a song is in favorites
  Future<bool> isFavorite(String title) async {
    final db = await database;
    final result = await db.query(
      'favourites',
      where: 'title = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty;
  }

  Future<void> addToFavorites(Song song) async {
    final db = await database;
    await db.insert(
      'favourites',
      {
        'title': song.title,
        'number': song.number,
        'markdown': song.markdown,
        'isFavorite': true,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a song from favorites
  Future<void> removeFromFavorites(String title) async {
    final db = await database;
    await db.delete(
      'favourites',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
