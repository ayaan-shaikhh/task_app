
import '../app_database.dart';
import '../../models/task.dart';

class TaskDatabaseOperations {
  // CREATE: Insert a new task.
  Future<int> insertTask(Task task) async {
    final db = await AppDatabase.database;

    final result = await db.rawInsert(
      '''
      INSERT INTO tasks (id, title, deadline, isCompleted)
      VALUES (?, ?, ?, ?)
      ''',
      [
        task.id,
        task.title,
        task.deadline.toIso8601String(),
        task.isCompleted ? 1 : 0,
      ],
    );

    return result;
  }

  // READ: Retrieve all tasks.
  Future<List<Task>> getAllTasks() async {
    final db = await AppDatabase.database;

    final List<Map<String, Object?>> rows =
        await db.rawQuery('SELECT * FROM tasks');

    return rows.map((row) {
      return Task(
        id: row['id'] as String,
        title: row['title'] as String,
        deadline: DateTime.parse(row['deadline'] as String),
        isCompleted: (row['isCompleted'] as int) == 1,
      );
    }).toList();
  }

  // UPDATE: Update an existing task.
  Future<int> updateTask(Task task) async {
    final db = await AppDatabase.database;

    final result = await db.rawUpdate(
      '''
      UPDATE tasks
      SET title = ?, deadline = ?, isCompleted = ?
      WHERE id = ?
      ''',
      [
        task.title,
        task.deadline.toIso8601String(),
        task.isCompleted ? 1 : 0,
        task.id,
      ],
    );

    return result;
  }

  // DELETE: Delete a task by its ID.
  Future<int> deleteTask(String id) async {
    final db = await AppDatabase.database;

    final result = await db.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    );

    return result;
  }
}
