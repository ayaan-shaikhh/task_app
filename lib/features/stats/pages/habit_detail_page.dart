import 'package:flutter/material.dart';
import '../../../core/models/habit_task.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_theme3.dart'; // for AppColors
import '../utils/habit_stats_calculator.dart';
import '../utils/stats_components.dart';

class HabitDetailPage extends StatelessWidget {
  const HabitDetailPage({
    super.key,
    required this.habit,
    required this.habitstore,
  });

  final HabitTask habit;
  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sheet,
      appBar: AppBar(
        backgroundColor: AppColors.sheet,
        foregroundColor: Colors.white,
        title: Text(habit.title, overflow: TextOverflow.ellipsis),
      ),
      // Rebuilds if the habit changes while this page is open.
      body: ListenableBuilder(
        listenable: habitstore,
        builder: (context, _) {
          final current = habitstore.habits.firstWhere(
            (h) => h.id == habit.id,
            orElse: () => habit,
          );
          final s = HabitStatsCalculator.compute(current);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _ringCard(s),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatsTile(
                      label: 'Best streak',
                      value: '${s.bestStreak}',
                      valueColor: AppColors.peach,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsTile(
                      label: 'Current streak',
                      value: '${s.currentStreak}',
                      valueColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatsTile(
                      label: 'Total completions',
                      value: '${s.totalCompletions}',
                      valueColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsTile(
                      label: 'Days per week',
                      value: '${current.frequency.length}',
                      valueColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _ringCard(HabitDetailStats s) {
    return StatsPanel(
      title: 'Last 30 days',
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: s.rate,
                    strokeWidth: 12,
                    backgroundColor: Colors.white12,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.peach),
                  ),
                ),
                Text(
                  '${(s.rate * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.doneDays} / ${s.scheduledDays}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.peach,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'scheduled days completed',
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}