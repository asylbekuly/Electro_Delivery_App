import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AvatarDB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'avatar.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE avatar(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> saveAvatarPath(String path) async {
    final db = await database;
    await db.delete('avatar'); // храним только 1 путь
    await db.insert('avatar', {'path': path});
  }

  static Future<String?> getAvatarPath() async {
    final db = await database;
    final result = await db.query('avatar', limit: 1);
    if (result.isNotEmpty) {
      return result.first['path'] as String;
    }
    return null;
  }
}
