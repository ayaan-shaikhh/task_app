
import '../database/operations/task_database_operations.dart';
import '../models/task.dart';

class TaskRepository {
  final TaskDatabaseOperations _databaseOperations =
      TaskDatabaseOperations();

  // Get all saved tasks from the database.
  Future<List<Task>> getAllTasks() async {
    return await _databaseOperations.getAllTasks();
  }

  // Add a new task to the database.
  Future<void> addTask(Task task) async {
    await _databaseOperations.insertTask(task);
  }

  // Update an existing task in the database.
  Future<void> updateTask(Task task) async {
    await _databaseOperations.updateTask(task);
  }

  // Delete a task from the database using its ID.
  Future<void> deleteTask(String id) async {
    await _databaseOperations.deleteTask(id);
  }
}
