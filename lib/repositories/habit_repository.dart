import '../database/habit_database_operations.dart';
import '../models/habit_task.dart';

class HabitRepository {
  final HabitDatabaseOperations _databaseOperations =
      HabitDatabaseOperations();

  // READ: Get all saved habits.
  Future<List<HabitTask>> getAllHabits() async {
    return await _databaseOperations.getAllHabits();
  }

  // CREATE: Save a new habit.
  Future<void> addHabit(HabitTask habit) async {
    await _databaseOperations.insertHabit(habit);
  }

  // UPDATE: Save changes to an existing habit.
  Future<void> updateHabit(HabitTask habit) async {
    await _databaseOperations.updateHabit(habit);
  }

  // DELETE: Remove a habit by its ID.
  Future<void> deleteHabit(String id) async {
    await _databaseOperations.deleteHabit(id);
  }
}