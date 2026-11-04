import 'package:flutter/material.dart';

import '../pages/create_task_page.dart';
import '../../habits/pages/create_habit_page.dart';

import '../../../core/theme/app_colors.dart';

import '../../../core/models/task.dart';
import '../../../core/models/habit_task.dart';

import '../../../core/stores/task_store.dart';
import '../../../core/stores/habit_store.dart';

class AddTaskSheet extends StatelessWidget {
  final TaskStore taskstore;
  final HabitStore habitstore;

  const AddTaskSheet({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    // Theme-aware accent colors
    final taskColor = customColors.warningText;
    final habitColor = customColors.successText;

    final taskForeground = customColors.warningTint;
    final habitForeground = customColors.successTint;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'What would you like to add?',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // TASK CARD
            Expanded(
              child: _buildOptionCard(
                context: context,
                title: 'Task',
                subtitle: 'Set a deadline and stay on track',
                icon: Icons.checklist_rounded,
                backgroundColor: taskColor,
                foregroundColor: taskForeground,
                onTap: () async {
                  final task = await Navigator.push<Task>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateTaskPage(),
                    ),
                  );

                  if (!context.mounted) return;

                  if (task != null) {
                    await taskstore.addTask(task);

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  }
                },
              ),
            ),

            const SizedBox(width: 12),

            // HABIT CARD
            Expanded(
              child: _buildOptionCard(
                context: context,
                title: 'Habit',
                subtitle: 'Build a routine, one day at a time',
                icon: Icons.repeat_rounded,
                backgroundColor: habitColor,
                foregroundColor: habitForeground,
                onTap: () async {
                  final habit = await Navigator.push<HabitTask>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateHabitPage(),
                    ),
                  );

                  if (!context.mounted) return;

                  if (habit != null) {
                    await habitstore.addHabit(habit);

                    if (!context.mounted) return;

                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: foregroundColor.withOpacity(0.08),
        highlightColor: foregroundColor.withOpacity(0.05),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withOpacity(0.7),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 52,
                color: foregroundColor,
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: foregroundColor.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}