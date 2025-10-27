import 'package:mindfulness_app/database/database_helper.dart';
import 'package:mindfulness_app/database/models/mood_entry.dart';
import 'package:sqflite/sqflite.dart';

class MoodHistoryRepository {
  final dbHelper = DatabaseHelper.instance;
  final tableName = 'mood_history';

  Future<List<MoodEntry>> getAll() async {
    final db = await dbHelper.database;
    final result = await db.query(tableName);
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  Future<List<MoodEntry>> getAllByDateDesc() async {
    final db = await dbHelper.database;
    final result = await db.query(tableName, orderBy: 'date DESC');
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  Future<MoodEntry?> getFirstWhereDateToday() async {
    String nowUtc = DateTime.now().toUtc().toIso8601String();
    final db = await dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'date(date) = date(?)',
      whereArgs: [nowUtc],
      limit: 1,
    );
    return result.isNotEmpty ? MoodEntry.fromMap(result.first) : null;
  }

  Future<List<Map<String, dynamic>>> getCountByMood() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT mood, COUNT(*) AS count FROM $tableName GROUP BY mood ORDER BY mood',
    );
    return result;
  }

  Future<int> save(MoodEntry entry) async {
    final db = await dbHelper.database;
    return await db.insert(
      tableName,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(MoodEntry entry) async {
    final db = await dbHelper.database;
    return await db.update(tableName, entry.toMap());
  }

  Future<int> deleteById(int id) async {
    final db = await dbHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
