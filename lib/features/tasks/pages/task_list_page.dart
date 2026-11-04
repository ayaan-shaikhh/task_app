import 'package:flutter/material.dart';

import '../../../core/models/task.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/task_row.dart';

/// Full page listing tasks grouped under their deadline date:
///
///   3/11/26
///     task one
///     task two
///   1/11/26
///     task one
class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key,
    required this.title,
    required this.taskstore,
  });

  final String title;
  final TaskStore taskstore;

  /// true  = latest date first (3/11 above 1/11, as in your example)
  /// false = earliest date first (1/11 above 3/11)
  static const bool _latestFirst = true;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Turns the sorted tasks into a flat list: a DateTime (header) followed by
  /// the Tasks of that date, then the next header, and so on.
  List<Object> _buildItems(List<Task> tasks) {
    final sorted = [...tasks];

    sorted.sort((a, b) {
      final dateCompare = _dateOnly(a.deadline).compareTo(_dateOnly(b.deadline));
      if (dateCompare != 0) {
        return _latestFirst ? -dateCompare : dateCompare;
      }
      // Same day: open tasks first, then by time.
      if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
      return a.deadline.compareTo(b.deadline);
    });

    final items = <Object>[];
    DateTime? currentDate;

    for (final task in sorted) {
      final date = _dateOnly(task.deadline);
      if (currentDate == null || date != currentDate) {
        currentDate = date;
        items.add(date); // header
      }
      items.add(task);
    }

    return items;
  }

  String _formatDate(DateTime d) {
    final yy = (d.year % 100).toString().padLeft(2, '0');
    return '${d.day}/${d.month}/$yy';
  }

  /// Small hint next to the date: Overdue / Today / Tomorrow.
  String? _relativeLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = date.difference(today).inDays;

    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return null;
  }

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
        listenable: taskstore,
        builder: (context, _) {
          final tasks = taskstore.tasks;

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks here yet',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          final items = _buildItems(tasks);

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];

              // ---- Date header ----
              if (item is DateTime) {
                final label = _relativeLabel(item);
                final isOverdue = label == 'Overdue';

                return Padding(
                  padding: EdgeInsets.fromLTRB(4, i == 0 ? 8 : 24, 4, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _formatDate(item),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (label != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isOverdue
                                ? customColors.errorText
                                : customColors.warningText,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              // ---- Task card ----
              final task = item as Task;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? customColors.successTint
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: TaskRow(
                    task: task,
                    onToggle: () => taskstore.toggle(task.id),
                    taskstore: taskstore,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}