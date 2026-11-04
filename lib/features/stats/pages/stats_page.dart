import 'package:flutter/material.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_theme3.dart'; // for AppColors

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  final TaskStore taskstore;
  final HabitStore habitstore;

  // ------------------------------------------------------------------
  // ADAPTERS: if your models use different field names, change ONLY these.
  // ------------------------------------------------------------------
  bool _taskDone(dynamic task) => task.isCompleted as bool;
  bool _habitDone(dynamic habit) => habit.isCompleted as bool;
  // ------------------------------------------------------------------

  static const _card = Color(0xFF151213);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gradient header, same look as the Calendar tab
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.calendarGradient),
          child: SafeArea(
            bottom: false,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stats',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your progress at a glance',
                    style: TextStyle(fontSize: 14, color: AppColors.ink),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Dark sheet
        Expanded(
          child: Container(
            color: AppColors.blush,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.sheet,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListenableBuilder(
                listenable: Listenable.merge([taskstore, habitstore]),
                builder: (context, _) => _buildBody(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final tasks = taskstore.tasks;
    final habits = habitstore.todayhabits;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final totalTasks = tasks.length;
    final doneTasks = tasks.where(_taskDone).length;
    final overdue = tasks
        .where((t) => !_taskDone(t) && t.deadline.isBefore(todayStart))
        .length;
    final rate = totalTasks == 0 ? 0.0 : doneTasks / totalTasks;

    final totalHabits = habits.length;
    final doneHabits = habits.where(_habitDone).length;
    final habitRate = totalHabits == 0 ? 0.0 : doneHabits / totalHabits;

    // Last 7 days (oldest -> today)
    final days = List.generate(
      7,
      (i) => todayStart.subtract(Duration(days: 6 - i)),
    );
    final dayTotals = days
        .map((d) => tasks.where((t) => _sameDay(t.deadline, d)).length)
        .toList();
    final dayDone = days
        .map(
          (d) => tasks
              .where((t) => _sameDay(t.deadline, d) && _taskDone(t))
              .length,
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        // Summary tiles
        Row(
          children: [
            Expanded(
              child: _tile('Completed', '$doneTasks', AppColors.peach),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _tile(
                'Overdue',
                '$overdue',
                overdue > 0 ? AppColors.blush : Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _tile('Total tasks', '$totalTasks', Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: _tile(
                'Completion rate',
                '${(rate * 100).round()}%',
                Colors.white,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Progress bars
        _panel(
          title: 'Progress',
          child: Column(
            children: [
              _progressRow('Tasks', rate, '$doneTasks / $totalTasks'),
              const SizedBox(height: 16),
              _progressRow('Habits today', habitRate, '$doneHabits / $totalHabits'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Last 7 days chart
        _panel(
          title: 'Tasks due, last 7 days',
          child: _buildBars(days, dayTotals, dayDone),
        ),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _tile(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _progressRow(String label, double value, String trailing) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            Text(trailing, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(AppColors.peach),
          ),
        ),
      ],
    );
  }

  Widget _buildBars(List<DateTime> days, List<int> totals, List<int> done) {
    const maxBarHeight = 100.0;
    final maxCount = totals.fold<int>(0, (m, v) => v > m ? v : m);
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final total = totals[i];
        final doneCount = done[i];
        final totalH = maxCount == 0 ? 3.0 : (maxBarHeight * total / maxCount).clamp(3.0, maxBarHeight);
        final doneH = maxCount == 0 ? 0.0 : maxBarHeight * doneCount / maxCount;

        return Column(
          children: [
            Text(
              '$total',
              style: const TextStyle(fontSize: 11, color: Colors.white60),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: maxBarHeight,
              width: 20,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: totalH,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    height: doneH,
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[days[i].weekday - 1],
              style: TextStyle(
                fontSize: 11,
                fontWeight: _sameDay(days[i], DateTime.now())
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: _sameDay(days[i], DateTime.now())
                    ? Colors.white
                    : Colors.white60,
              ),
            ),
          ],
        );
      }),
    );
  }
}