import 'package:mindfulness_app/database/database_helper.dart';
import 'package:mindfulness_app/database/models/journal_entry.dart';
import 'package:sqflite/sqflite.dart';

class JournalRepository {
  final dbHelper = DatabaseHelper.instance;
  final tableName = 'journal';

  Future<List<JournalEntry>> getAll() async {
    final db = await dbHelper.database;
    final result = await db.query(tableName);
    return result.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<List<JournalEntry>> getAllByDateDesc() async {
    final db = await dbHelper.database;
    final result = await db.query(tableName, orderBy: 'date DESC');
    return result.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<List<JournalEntry>> getFirstWhereDateToday() async {
    final db = await dbHelper.database;
    final result = await db.query(
      tableName,
      where: 'date(date) = date(?)',
      whereArgs: ['now'],
      limit: 1,
    );
    return result.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<int> add(JournalEntry entry) async {
    final db = await dbHelper.database;
    return await db.insert(
      tableName,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(JournalEntry entry) async {
    final db = await dbHelper.database;
    return await db.update(tableName, entry.toMap());
  }

  Future<int> deleteById(int id) async {
    final db = await dbHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
