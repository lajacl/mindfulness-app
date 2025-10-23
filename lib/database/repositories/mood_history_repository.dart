import '../database_helper.dart';
import '../models/mood_entry.dart';

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

  Future<List<MoodEntry>> getFirstWhereDateToday() async {
    final db = await dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'date(date) = date(?)',
      whereArgs: ['now'],
      limit: 1,
    );
    return result.map((map) => MoodEntry.fromMap(map)).toList();
  }

  Future<int> add(MoodEntry entry) async {
    final db = await dbHelper.database;
    return await db.insert(tableName, entry.toMap());
  }

  Future<int> update(MoodEntry entry) async {
    final db = await dbHelper.database;
    return await db.update(tableName, entry.toMap());
  }

  Future<int> deleteById(DateTime id) async {
    final db = await dbHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
