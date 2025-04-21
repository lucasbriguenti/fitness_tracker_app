import 'package:fitness_tracker/models/exercicie_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseRepository {
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'exercicies.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE exercicies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            repetition INTEGER,
            interval INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertExercicie(Exercicie exercicie) async {
    final db = await _database;
    return await db.insert(
      'exercicies',
      exercicie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercicie>> getAllExercicies() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('exercicies');
    return maps.map((map) => Exercicie.fromMap(map)).toList();
  }

  Future<List<Exercicie>> getByIds(List<int> ids) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercicies',
      where: 'id IN (?)',
      whereArgs: [ids],
    );
    return maps.map((map) => Exercicie.fromMap(map)).toList();
  }

  Future<void> updateExercicie(Exercicie exercicie) async {
    final db = await _database;
    await db.update(
      'exercicies',
      exercicie.toMap(),
      where: 'id = ?',
      whereArgs: [exercicie.id],
    );
  }

  Future<void> deleteExercicie(int id) async {
    final db = await _database;
    await db.delete('exercicies', where: 'id = ?', whereArgs: [id]);
  }
}
