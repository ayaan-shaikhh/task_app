import 'package:flutter/material.dart';

import '../../../core/stores/habit_store.dart';
import '../../../core/models/habit_task.dart';
import '../pages/edit_habit_page.dart';

import '../../../core/theme/app_colors.dart';

/// One habit: completion button, title and edit/navigation icon.
class HabitRow extends StatelessWidget {
  const HabitRow({
    super.key,
    required this.habit,
    required this.date,
    required this.onToggle,
    required this.habitstore,
  });

  final HabitTask habit;

  /// The day this row is being shown for (selected calendar day, or today).
  final DateTime date;

  final VoidCallback onToggle;
  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    final isDone = habit.isCompletedOn(date);

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              tooltip: isDone ? 'Mark as not done' : 'Mark as done',
              onPressed: onToggle,
              icon: Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone
                    ? customColors.successText
                    : const Color(0xFFB6BDC8),
                size: 26,
              ),
            ),
            Expanded(
              child: Text(
                habit.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: isDone
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Edit habit',
              icon: const Icon(Icons.chevron_right),
              color: const Color(0xFFB6BDC8),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditHabitPage(
                      habit: habit,
                      habitstore: habitstore,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}