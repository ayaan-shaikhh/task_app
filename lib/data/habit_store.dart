import 'package:flutter/foundation.dart';

import '../models/habit_task.dart';
import '../repositories/habit_repository.dart';

class HabitStore extends ChangeNotifier {
  final HabitRepository _habitRepository = HabitRepository();

  final List<HabitTask> _habits = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Loads habits saved in SQLite.
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedHabits = await _habitRepository.getAllHabits();

      _habits
        ..clear()
        ..addAll(savedHabits);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Returns habits sorted by completion status and title.
  List<HabitTask> get habits {
    return _sorted(_habits);
  }

  List<HabitTask> get todayhabits{
    final today = Weekday.values[DateTime.now().weekday - 1];

    final todaysHabits = _habits.where((habit) {
      return habit.frequency.contains(today);
    });

    return _sorted(todaysHabits);
  }

  /// Adds a new habit to SQLite.
  Future<void> add({required String title}) async {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) return;

    final habit = HabitTask(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
    );

    await _habitRepository.addHabit(habit);

    _habits.add(habit);
    notifyListeners();
  }

  /// Adds an existing HabitTask to SQLite.
  Future<void> addHabit(HabitTask habit) async {
    await _habitRepository.addHabit(habit);

    _habits.add(habit);
    notifyListeners();
  }

  /// Toggles completion and saves the change.
  Future<void> toggle(String id) async {
    final index = _habits.indexWhere((habit) => habit.id == id);

    if (index == -1) return;

    final updatedHabit = _habits[index].copyWith(
      isCompleted: !_habits[index].isCompleted,
    );

    await _habitRepository.updateHabit(updatedHabit);

    _habits[index] = updatedHabit;
    notifyListeners();
  }

  Future<void> updateHabit(HabitTask habit) async {
  final index = _habits.indexWhere((item) => item.id == habit.id);

  if (index == -1) return;

  await _habitRepository.updateHabit(habit);

  _habits[index] = habit;
  notifyListeners();
}

  /// Deletes a habit from SQLite.
  Future<void> remove(String id) async {
    final index = _habits.indexWhere((habit) => habit.id == id);

    if (index == -1) return;

    await _habitRepository.deleteHabit(id);

    _habits.removeAt(index);
    notifyListeners();
  }

  List<HabitTask> _sorted(Iterable<HabitTask> list) {
    final items = list.toList();

    items.sort((a, b) {
      // Incomplete habits come before completed habits.
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Sort alphabetically when completion status is the same.
      return a.title.compareTo(b.title);
    });

    return items;
  }
}
