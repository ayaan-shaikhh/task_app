import 'package:flutter/material.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/theme/app_theme3.dart';
import '../utils/stats_calculator.dart';
import '../utils/stats_components.dart';
import '../utils/days_range_selector.dart';

class TaskStatsBody extends StatefulWidget {
  const TaskStatsBody({super.key, required this.taskstore});

  final TaskStore taskstore;

  @override
  State<TaskStatsBody> createState() => _TaskStatsBodyState();
}

class _TaskStatsBodyState extends State<TaskStatsBody> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final s = StatsCalculator.tasks(widget.taskstore.tasks, days: _days);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        DaysRangeSelector(
          days: _days,
          onChanged: (d) => setState(() => _days = d),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsTile(
                  label: 'Completed',
                  value: '${s.done}',
                  valueColor: AppColors.peach),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsTile(
                label: 'Overdue',
                value: '${s.overdue}',
                valueColor: s.overdue > 0 ? AppColors.blush : Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsTile(
                  label: 'Total tasks',
                  value: '${s.total}',
                  valueColor: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsTile(
                label: 'Completion rate',
                value: '${(s.rate * 100).round()}%',
                valueColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        StatsPanel(
          title: 'Progress',
          child: StatsProgressRow(
            label: 'Tasks',
            value: s.rate,
            trailing: '${s.done} / ${s.total}',
          ),
        ),
        const SizedBox(height: 16),
        StatsPanel(
          title: 'Tasks due, last $_days days',
          child: _buildBars(s),
        ),
      ],
    );
  }

  String _label(TaskStatsData s, int i) {
    final d = s.bucketStarts[i];
    if (s.bucketSize == 1 && _days <= 7) {
      const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return letters[d.weekday - 1];
    }
    return '${d.day}/${d.month}';
  }

// for the stats part wiht the graphs, we will use a simple bar chart representation using containers. Each bar will represent the number of tasks due on that day, and the height of the bar will be proportional to the number of tasks. The color of the bar will indicate how many tasks were completed.
  Widget _buildBars(TaskStatsData s) {
    const maxBarHeight = 100.0;
    final maxCount = s.bucketTotals.fold<int>(0, (m, v) => v > m ? v : m);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(s.bucketTotals.length, (i) {
        final total = s.bucketTotals[i];
        final doneCount = s.bucketDone[i];
        final totalH = maxCount == 0
            ? 3.0
            : (maxBarHeight * total / maxCount).clamp(3.0, maxBarHeight);
        final doneH = maxCount == 0 ? 0.0 : maxBarHeight * doneCount / maxCount;

        final bStart = s.bucketStarts[i];
        final bEnd = bStart.add(Duration(days: s.bucketSize - 1));
        final isCurrent = !today.isBefore(bStart) && !today.isAfter(bEnd);

        return Expanded(
          child: Column(
            children: [
              Text('$total',
                  style: const TextStyle(fontSize: 10, color: Colors.white60)),
              const SizedBox(height: 4),
              SizedBox(
                height: maxBarHeight,
                width: 14,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: totalH,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    Container(
                      height: doneH,
                      decoration: BoxDecoration(
                        color: AppColors.peach,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _label(s, i),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent ? Colors.white : Colors.white60,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}