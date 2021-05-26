import 'package:path/path.dart';
import 'package:photopuzzle/common/config.dart';
import 'package:photopuzzle/database/puzzle_mock_model.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  static Database _db;
  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  Future<Database> initDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, Config.databaseName);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE PuzzleMockTable(id INTEGER PRIMARY KEY, name TEXT)');
  }

  Future<void> insertPuzzleMockData(PuzzleMockModel model) async {
    // Get a reference to the database.
    var dbClient = await db;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await dbClient.insert(
      'PuzzleMockTable',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String> getPuzzleMockModel(int id) async {
    var dbClient = await db;
    List<Map> result =
        await dbClient.query('PuzzleMockTable', where: '$id = 001');

    if (result.isNotEmpty) {
      return result.first.toString();
    }

    return null;
  }
}
