import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/favorite_model.dart';

class FavoriteDB {
  static final FavoriteDB _instance = FavoriteDB._();
  static Database? _database;

  FavoriteDB._();

  factory FavoriteDB() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("favorites.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image TEXT,
        price REAL
      )
    ''');
  }

  Future<int> addFavorite(FavoriteModel favorite) async {
    final db = await database;
    return await db.insert('favorites', favorite.toMap());
  }

  Future<List<FavoriteModel>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((map) => FavoriteModel.fromMap(map)).toList();
  }

  Future<int> deleteFavorite(int id) async {
    final db = await database;
    return await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
