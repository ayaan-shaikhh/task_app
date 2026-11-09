import '../../../core/models/task.dart';
import '../../../core/models/habit_task.dart';

class TaskStatsData {
  const TaskStatsData({
    required this.total,
    required this.done,
    required this.overdue,
    required this.rate,
    required this.bucketStarts,
    required this.bucketSize,
    required this.bucketTotals,
    required this.bucketDone,
  });

  final int total;
  final int done;
  final int overdue;
  final double rate;
  final List<DateTime> bucketStarts; // first day of each bar
  final int bucketSize; // days per bar
  final List<int> bucketTotals;
  final List<int> bucketDone;
}

class HabitStatsData {
  const HabitStatsData({
    required this.total,
    required this.done,
    required this.rate,
  });

  final int total;
  final int done;
  final double rate;
}

class StatsCalculator {
  static bool taskDone(Task task) => task.isCompleted;

  /// A habit counts as done if it was completed on [date] (default: today).
  static bool habitDone(HabitTask habit, [DateTime? date]) =>
      habit.isCompletedOn(date ?? DateTime.now());

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static TaskStatsData tasks(List<Task> allTasks, {int days = 7}) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final start = todayStart.subtract(Duration(days: days - 1));

    // Only tasks due inside the window [start, today]
    final inRange = allTasks.where((t) {
      final d = _dayOnly(t.deadline);
      return !d.isBefore(start) && !d.isAfter(todayStart);
    }).toList();

    final total = inRange.length;
    final done = inRange.where(taskDone).length;
    final overdue = inRange
        .where((t) => !taskDone(t) && t.deadline.isBefore(todayStart))
        .length;
    final rate = total == 0 ? 0.0 : done / total;

    // Daily bars up to 14 days, otherwise grouped into <= 14 bars
    final bucketSize = days <= 14 ? 1 : (days / 14).ceil();
    final bucketCount = (days / bucketSize).ceil();

    final starts = <DateTime>[];
    final totals = <int>[];
    final doneCounts = <int>[];

    for (var i = 0; i < bucketCount; i++) {
      final bStart = start.add(Duration(days: i * bucketSize));
      final bEnd = bStart.add(Duration(days: bucketSize - 1));
      final items = inRange.where((t) {
        final d = _dayOnly(t.deadline);
        return !d.isBefore(bStart) && !d.isAfter(bEnd);
      }).toList();
      starts.add(bStart);
      totals.add(items.length);
      doneCounts.add(items.where(taskDone).length);
    }

    return TaskStatsData(
      total: total,
      done: done,
      overdue: overdue,
      rate: rate,
      bucketStarts: starts,
      bucketSize: bucketSize,
      bucketTotals: totals,
      bucketDone: doneCounts,
    );
  }

  /// Completion of today's habits (pass `habitstore.todayhabits`).
  static HabitStatsData habitsToday(List<HabitTask> habits) {
    final total = habits.length;
    final done = habits.where((h) => habitDone(h)).length;
    return HabitStatsData(
      total: total,
      done: done,
      rate: total == 0 ? 0.0 : done / total,
    );
  }
}