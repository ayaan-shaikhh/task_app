
import 'package:flutter/material.dart';

class StatsProgressPanel extends StatelessWidget {
  const StatsProgressPanel({
    super.key,
    required this.taskRate,
    required this.habitRate,
    required this.doneTasks,
    required this.totalTasks,
    required this.doneHabits,
    required this.totalHabits,
  });

  final double taskRate;
  final double habitRate;

  final int doneTasks;
  final int totalTasks;

  final int doneHabits;
  final int totalHabits;

  static const _card = Color(0xFF151213);

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          _progressRow(
            label: 'Tasks',
            value: taskRate,
            trailing: '$doneTasks / $totalTasks',
          ),

          const SizedBox(height: 20),

          _progressRow(
            label: 'Habits',
            value: habitRate,
            trailing: '$doneHabits / $totalHabits',
          ),
        ],
      ),
    );
  }

  Widget _progressRow({
    required String label,
    required double value,
    required String trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              trailing,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(
              Color(0xFFF7E7CE),
            ),
          ),
        ),
      ],
    );
  }
}
