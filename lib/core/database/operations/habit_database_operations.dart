import 'dart:convert';

import '../app_database.dart';
import '../../models/habit_task.dart';

class HabitDatabaseOperations {
  // CREATE: Insert a new habit (and any completions it already has).
  Future<int> insertHabit(HabitTask habit) async {
    final db = await AppDatabase.database;

    final frequencyJson = jsonEncode(
      habit.frequency.map((day) => day.name).toList(),
    );

    return db.transaction((txn) async {
      // isCompleted is legacy; it is left out and uses its default of 0.
      final result = await txn.rawInsert(
        '''
        INSERT INTO habits (id, title, frequency)
        VALUES (?, ?, ?)
        ''',
        [habit.id, habit.title, frequencyJson],
      );

      for (final date in habit.completedDates) {
        await txn.rawInsert(
          '''
          INSERT OR IGNORE INTO habit_completions (habit_id, date)
          VALUES (?, ?)
          ''',
          [habit.id, date],
        );
      }

      return result;
    });
  }

  // READ: Retrieve all habits with their completed dates.
  Future<List<HabitTask>> getAllHabits() async {
    final db = await AppDatabase.database;

    final habitRows = await db.rawQuery('SELECT * FROM habits');
    final completionRows = await db.rawQuery(
      'SELECT habit_id, date FROM habit_completions',
    );

    // Group completions by habit id: { habitId: {"2026-11-07", ...} }
    final Map<String, Set<String>> completionsByHabit = {};
    for (final row in completionRows) {
      final habitId = row['habit_id'] as String;
      final date = row['date'] as String;
      completionsByHabit.putIfAbsent(habitId, () => <String>{}).add(date);
    }

    return habitRows.map((row) {
      final List<dynamic> frequencyList =
          jsonDecode(row['frequency'] as String) as List<dynamic>;

      final frequency = frequencyList
          .map((day) => Weekday.values.byName(day as String))
          .toSet();

      final id = row['id'] as String;

      return HabitTask(
        id: id,
        title: row['title'] as String,
        frequency: frequency,
        completedDates: completionsByHabit[id] ?? <String>{},
      );
    }).toList();
  }

  // UPDATE: Update a habit and make its stored completions match the model.
  Future<int> updateHabit(HabitTask habit) async {
    final db = await AppDatabase.database;

    final frequencyJson = jsonEncode(
      habit.frequency.map((day) => day.name).toList(),
    );

    return db.transaction((txn) async {
      final result = await txn.rawUpdate(
        '''
        UPDATE habits
        SET title = ?, frequency = ?
        WHERE id = ?
        ''',
        [habit.title, frequencyJson, habit.id],
      );

      // Replace this habit's completions with the current set.
      await txn.rawDelete(
        'DELETE FROM habit_completions WHERE habit_id = ?',
        [habit.id],
      );

      for (final date in habit.completedDates) {
        await txn.rawInsert(
          '''
          INSERT OR IGNORE INTO habit_completions (habit_id, date)
          VALUES (?, ?)
          ''',
          [habit.id, date],
        );
      }

      return result;
    });
  }

  // DELETE: Delete a habit and its completions.
  Future<int> deleteHabit(String id) async {
    final db = await AppDatabase.database;

    return db.transaction((txn) async {
      // Explicit delete, so it works even if foreign keys are off.
      await txn.rawDelete(
        'DELETE FROM habit_completions WHERE habit_id = ?',
        [id],
      );

      return txn.rawDelete('DELETE FROM habits WHERE id = ?', [id]);
    });
  }
}