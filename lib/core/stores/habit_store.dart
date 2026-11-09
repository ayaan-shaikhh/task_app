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

  /// All habits (not date-specific), sorted by title.
  List<HabitTask> get habits {
    final items = _habits.toList();
    items.sort((a, b) => a.title.compareTo(b.title));
    return items;
  }

  /// Habits scheduled on [date]: incomplete first, then completed, then A-Z.
  List<HabitTask> habitsForDate(DateTime date) {
    final day = Weekday.values[date.weekday - 1];

    final matching = _habits.where((habit) {
      return habit.frequency.contains(day);
    });

    return _sorted(matching, date);
  }

  List<HabitTask> get todayhabits => habitsForDate(DateTime.now());

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

  /// Toggles completion for a single date and saves the change.
  Future<void> toggle(String id, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = _habits[index];
    final key = HabitTask.dateKey(date);

    final updatedDates = {...habit.completedDates};
    if (updatedDates.contains(key)) {
      updatedDates.remove(key);
    } else {
      updatedDates.add(key);
    }

    final newHabit = habit.copyWith(completedDates: updatedDates);

    await _habitRepository.updateHabit(newHabit);

    _habits[index] = newHabit;
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

  List<HabitTask> _sorted(Iterable<HabitTask> list, DateTime date) {
    final items = list.toList();

    items.sort((a, b) {
      final aDone = a.isCompletedOn(date);
      final bDone = b.isCompletedOn(date);

      // Incomplete habits come before completed habits.
      if (aDone != bDone) {
        return aDone ? 1 : -1;
      }

      // Sort alphabetically when completion status is the same.
      return a.title.compareTo(b.title);
    });

    return items;
  }
}