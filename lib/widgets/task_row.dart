import 'package:flutter/material.dart';

import '../models/task.dart';
import 'pill.dart';

// import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

import '../data/task_store.dart';
import '../pages/edit_task_page.dart';

/// One task: round check button, title, a status pill and a chevron.
class TaskRow extends StatelessWidget {
  const TaskRow({
    super.key,
    required this.task,
    required this.onToggle,
    required this.taskstore,
  });

  final Task task;
  final VoidCallback onToggle;
  final TaskStore taskstore;

  Widget _pill(BuildContext context) {
    final due = task.deadline;
    final now = DateTime.now();

    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    // Compare the complete date and time.
    if (due.isBefore(now)) {
      return Pill(
        label: 'Overdue',
        background: customColors.errorTint,
        foreground: customColors.errorText,
      );
    }

    final today = DateTime(now.year, now.month, now.day);

    final days = DateTime(
      due.year,
      due.month,
      due.day,
    ).difference(today).inDays;

    if (days == 0) {
      return Pill(
        label: 'Today',
        background: customColors.warningTint,
        foreground: customColors.warningText,
      );
    }

    if (days == 1) {
      return Pill(
        label: 'Tomorrow',
        background: customColors.greyTint,
        foreground: colorScheme.onSurfaceVariant,
      );
    }

    return Pill(
      label: '${due.day}/${due.month}',
      background: customColors.greyTint,
      foreground: colorScheme.onSurfaceVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              tooltip: task.isCompleted ? 'Mark as not done' : 'Mark as done',
              onPressed: onToggle,
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted
                    ? customColors.successText
                    : colorScheme.outline,
                size: 26,
              ),
            ),
            Expanded(
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: task.isCompleted
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (!task.isCompleted) _pill(context),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditTaskPage(task: task, taskstore: taskstore),
                  ),
                );
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Color(0xFFB6BDC8),
                size: 20,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
