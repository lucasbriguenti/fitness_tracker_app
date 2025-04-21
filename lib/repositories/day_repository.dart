import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/models/exercicie_model.dart';
import 'package:fitness_tracker/repositories/exercise_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DayRepository {
  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'days.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE days (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE day_exercises (
            day_id INTEGER,
            exercise_id INTEGER,
            FOREIGN KEY(day_id) REFERENCES days(id),
            FOREIGN KEY(exercise_id) REFERENCES exercicies(id)
          )
        ''');
      },
    );
  }

  final _exerciseRepo = getIt<ExerciseRepository>();

  Future<int> insertDay(Day day) async {
    final db = await _database;

    final dayId = await db.insert('days', {
      'name': day.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    for (var exercicie in day.exercicies) {
      final exerciseId =
          exercicie.id ?? await _exerciseRepo.insertExercicie(exercicie);

      await db.insert('day_exercises', {
        'day_id': dayId,
        'exercise_id': exerciseId,
      });
    }

    return dayId;
  }

  Future insertExerciciesDays(int dayId, List<int> exerciseIds) async {
    final db = await _database;

    for (var exerciseId in exerciseIds) {
      await db.insert('day_exercises', {
        'day_id': dayId,
        'exercise_id': exerciseId,
      });
    }
  }

  Future<Day?> getDayById(int id) async {
    final db = await _database;

    final List<Map<String, dynamic>> dayMaps = await db.query(
      'days',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (dayMaps.isEmpty) return null;

    final dayMap = dayMaps.first;

    // Buscar as relações com exercícios
    final List<Map<String, dynamic>> relationMaps = await db.query(
      'day_exercises',
      where: 'day_id = ?',
      whereArgs: [id],
    );

    final exerciseIds =
        relationMaps.map((e) => e['exercise_id'] as int).toList();

    final exercises = <Exercicie>[];
    for (var exerciseId in exerciseIds) {
      final all = await _exerciseRepo.getAllExercicies();
      final found = all.firstWhere(
        (ex) => ex.id == exerciseId,
        orElse: () => throw Exception("Exercício não encontrado"),
      );
      exercises.add(found);
    }

    return Day(id: dayMap['id'], name: dayMap['name'], exercicies: exercises);
  }

  Future<List<Day>> getAllDays() async {
    final db = await _database;

    final List<Map<String, dynamic>> dayMaps = await db.query('days');

    List<Day> days = [];

    for (var dayMap in dayMaps) {
      final dayId = dayMap['id'];

      final List<Map<String, dynamic>> relationMaps = await db.query(
        'day_exercises',
        where: 'day_id = ?',
        whereArgs: [dayId],
      );

      final exerciseIds =
          relationMaps.map((e) => e['exercise_id'] as int).toList();

      final exercises = <Exercicie>[];
      for (var id in exerciseIds) {
        final all = await _exerciseRepo.getAllExercicies();
        final found = all.firstWhere(
          (ex) => ex.id == id,
          orElse: () => throw Exception("Exercício não encontrado"),
        );
        exercises.add(found);
      }

      days.add(Day(id: dayId, name: dayMap['name'], exercicies: exercises));
    }

    return days;
  }

  Future<void> deleteDay(int id) async {
    final db = await _database;

    await db.delete('day_exercises', where: 'day_id = ?', whereArgs: [id]);

    await db.delete('days', where: 'id = ?', whereArgs: [id]);
  }
}
