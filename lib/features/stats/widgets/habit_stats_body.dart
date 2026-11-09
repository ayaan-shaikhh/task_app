import 'package:flutter/material.dart';
import '../../../core/stores/habit_store.dart';
import '../utils/stats_calculator.dart';
import 'habit_list_view.dart';
import '../utils/stats_components.dart';

class HabitStatsBody extends StatelessWidget {
  const HabitStatsBody({super.key, required this.habitstore});

  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    final s = StatsCalculator.habitsToday(habitstore.todayhabits);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        StatsPanel(
          title: 'Progress for today',
          child: StatsProgressRow(
            label: 'Habits today',
            value: s.rate,
            trailing: '${s.done} / ${s.total}',
          ),
        ),
        const SizedBox(height: 16),
        HabitListView(habitstore: habitstore),
      ],
    );
  }
}