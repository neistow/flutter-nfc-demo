import 'package:key_finder/models/key_tag.dart';
import 'package:sqflite/sqflite.dart';

class KeyTagStorage {
  static final KeyTagStorage instance = KeyTagStorage._internal();

  static Database? _databaseInstance;

  KeyTagStorage._internal();

  Future<Database> get _database async {
    if (_databaseInstance != null) {
      return _databaseInstance!;
    }

    _databaseInstance = await _initDatabase();
    return _databaseInstance!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/notes.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE KeyTags (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT NOT NULL
        )
      ''');
  }

  Future<List<KeyTagModel>> getAll() async {
    final db = await instance._database;
    final result = await db.query("KeyTags");
    return result.map((json) => KeyTagModel.fromJson(json)).toList();
  }

  Future<KeyTagModel?> getById(String id) async {
    final db = await instance._database;
    final results = await db.query(
      "KeyTags",
      where: 'id = ?',
      limit: 1,
      whereArgs: [id],
    );

    if (results.isEmpty) {
      return null;
    }

    return KeyTagModel.fromJson(results.first);
  }

  Future<void> create(KeyTagModel model) async {
    final db = await instance._database;
    await db.insert("KeyTags", model.toJson());
  }

  Future<void> delete(String id) async {
    final db = await instance._database;
    await db.delete(
      "KeyTags",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance._database;
    db.close();
  }
}
