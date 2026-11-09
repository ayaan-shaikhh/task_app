import 'package:flutter/material.dart';
import '../../../core/models/habit_task.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_theme3.dart'; // for AppColors
import '../pages/habit_detail_page.dart';
import '../utils/stats_components.dart'; // for statsCardColor

/// A column of every habit the user has created. Tapping one opens its page.
class HabitListView extends StatelessWidget {
  const HabitListView({super.key, required this.habitstore});

  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    final habits = habitstore.habits; // all habits, sorted by title

    if (habits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No habits yet',
            style: TextStyle(color: Colors.white60),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final habit in habits)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _HabitCard(habit: habit, habitstore: habitstore),
          ),
      ],
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit, required this.habitstore});

  final HabitTask habit;
  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: statsCardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                HabitDetailPage(habit: habit, habitstore: habitstore),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.peach,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  habit.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}