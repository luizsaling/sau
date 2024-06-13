import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/mood.dart';

class DatabaseService {
  static final String _databaseName = "sau.db";
  static final int _databaseVersion = 1;

  static final String table = 'mood';

  static final String columnId = '_id';
  static final String columnMood = 'mood';
  static final String columnDate = 'date';

  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnMood TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Mood mood) async {
    final Database db = await instance.database;
    return await db.insert(table, mood.toMap());
  }

  Future<List<Mood>> queryAllRows() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> allRows = await db.query(table);
    return allRows
        .map((row) => Mood(
              id: row[columnId] as int,
              mood: row[columnMood] as String,
              date: row[columnDate] as String,
            ))
        .toList();
  }
}
