import '../../../core/models/habit_task.dart';

class HabitDetailStats {
  const HabitDetailStats({
    required this.scheduledDays,
    required this.doneDays,
    required this.rate,
    required this.bestStreak,
    required this.currentStreak,
    required this.totalCompletions,
  });

  final int scheduledDays; // scheduled days in the window
  final int doneDays; // of those, how many were completed
  final double rate; // doneDays / scheduledDays
  final int bestStreak;
  final int currentStreak;
  final int totalCompletions;
}

class HabitStatsCalculator {
  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _addDays(DateTime d, int n) =>
      DateTime(d.year, d.month, d.day + n);

  static bool _scheduled(HabitTask habit, DateTime d) =>
      habit.frequency.contains(Weekday.values[d.weekday - 1]);

  static HabitDetailStats compute(HabitTask habit, {int windowDays = 30}) {
    final today = _dayOnly(DateTime.now());
    final windowStart = _addDays(today, -(windowDays - 1));

    // ---- Ring: scheduled vs completed in the window ----
    var scheduled = 0;
    var done = 0;
    for (var i = 0; i < windowDays; i++) {
      final d = _addDays(windowStart, i);
      if (_scheduled(habit, d)) {
        scheduled++;
        if (habit.isCompletedOn(d)) done++;
      }
    }

    // ---- Streaks: walk from the first completion up to today ----
    var best = 0;
    var run = 0;

    if (habit.completedDates.isNotEmpty) {
      final first = habit.completedDates
          .map((k) => _dayOnly(DateTime.parse(k)))
          .reduce((a, b) => a.isBefore(b) ? a : b);

      for (var d = first; !d.isAfter(today); d = _addDays(d, 1)) {
        if (habit.isCompletedOn(d)) {
          run++;
          if (run > best) best = run;
        } else if (_scheduled(habit, d)) {
          if (d == today) continue; // today is still open, don't break
          run = 0;
        }
        // not scheduled and not completed: skip, streak continues
      }
    }

    return HabitDetailStats(
      scheduledDays: scheduled,
      doneDays: done,
      rate: scheduled == 0 ? 0.0 : done / scheduled,
      bestStreak: best,
      currentStreak: run,
      totalCompletions: habit.completedDates.length,
    );
  }
}