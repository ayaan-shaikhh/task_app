import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskStore extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  final List<Task> _tasks = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Loads tasks saved in SQLite.
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedTasks = await _taskRepository.getAllTasks();

      _tasks
        ..clear()
        ..addAll(savedTasks);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Open tasks first, finished ones after them.
  List<Task> _sorted(Iterable<Task> list) {
    final items = list.toList();

    items.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      return a.deadline.compareTo(b.deadline);
    });

    return items;
  }

  List<Task> get tasks => _sorted(_tasks);

  /// Toggles completion and saves the change.
  Future<void> toggle(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) return;

    final updatedTask = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );

    await _taskRepository.updateTask(updatedTask);

    _tasks[index] = updatedTask;
    notifyListeners();
  }

  /// Adds a new task to SQLite.
  Future<void> add({required String title, required DateTime deadline}) async {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) return;

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      deadline: deadline,
    );

    await _taskRepository.addTask(task);

    _tasks.add(task);
    notifyListeners();
  }

  /// Adds an already-created task to SQLite.
  Future<void> addTask(Task task) async {
    await _taskRepository.addTask(task);

    _tasks.add(task);
    notifyListeners();
  }

  /// Updates an existing task in SQLite.
Future<void> updateTask(Task task) async {
  final index = _tasks.indexWhere((item) => item.id == task.id);

  if (index == -1) return;

  await _taskRepository.updateTask(task);

  _tasks[index] = task;

  notifyListeners();
}
}
