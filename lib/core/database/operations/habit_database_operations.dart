import 'dart:convert';

// import 'package:sqflite/sqflite.dart';

import '../app_database.dart';
import '../../models/habit_task.dart';

class HabitDatabaseOperations {
  // CREATE: Insert a new habit.
  Future<int> insertHabit(HabitTask habit) async {
    final db = await AppDatabase.database;

    final frequencyJson = jsonEncode(
      habit.frequency.map((day) => day.name).toList(),
    );

    final result = await db.rawInsert(
      '''
      INSERT INTO habits (id, title, frequency, isCompleted)
      VALUES (?, ?, ?, ?)
      ''',
      [
        habit.id,
        habit.title,
        frequencyJson,
        habit.isCompleted ? 1 : 0,
      ],
    );

    return result;
  }

  // READ: Retrieve all habits.
  Future<List<HabitTask>> getAllHabits() async {
    final db = await AppDatabase.database;

    final List<Map<String, Object?>> rows =
        await db.rawQuery('SELECT * FROM habits');

    return rows.map((row) {
      final List<dynamic> frequencyList =
          jsonDecode(row['frequency'] as String) as List<dynamic>;

      final frequency = frequencyList
          .map(
            (day) => Weekday.values.byName(day as String),
          )
          .toSet();

      return HabitTask(
        id: row['id'] as String,
        title: row['title'] as String,
        frequency: frequency,
        isCompleted: (row['isCompleted'] as int) == 1,
      );
    }).toList();
  }

  // UPDATE: Update an existing habit.
  Future<int> updateHabit(HabitTask habit) async {
    final db = await AppDatabase.database;

    final frequencyJson = jsonEncode(
      habit.frequency.map((day) => day.name).toList(),
    );

    final result = await db.rawUpdate(
      '''
      UPDATE habits
      SET title = ?, frequency = ?, isCompleted = ?
      WHERE id = ?
      ''',
      [
        habit.title,
        frequencyJson,
        habit.isCompleted ? 1 : 0,
        habit.id,
      ],
    );

    return result;
  }

  // DELETE: Delete a habit by its ID.
  Future<int> deleteHabit(String id) async {
    final db = await AppDatabase.database;

    final result = await db.rawDelete(
      'DELETE FROM habits WHERE id = ?',
      [id],
    );

    return result;
  }
}
