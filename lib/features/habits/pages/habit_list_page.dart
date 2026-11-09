import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';

import '../../../core/stores/habit_store.dart';

import '../../../core/theme/app_colors.dart';

import '../widgets/habit_row.dart';

class HabitListPage extends StatelessWidget {
  const HabitListPage({super.key, required this.title, required this.store});

  final String title;
  final HabitStore store;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: customColors.warningText),
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final habits = store.habits;
          final today = DateTime.now();

          if (habits.isEmpty) {
            return Center(
              child: Text(
                'No habits here yet',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: habits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final habit = habits[i];
              return Container(
                decoration: BoxDecoration(
                  color: habit.isCompletedOn(today)
                      ? customColors.successTint
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: HabitRow(
                  habit: habit,
                  date: today,
                  habitstore: store,
                  onToggle: () => store.toggle(habit.id, today),
                ),
              );
            },
          );
        },
      ),
    );
  }
}