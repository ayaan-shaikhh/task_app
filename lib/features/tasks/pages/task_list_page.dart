import 'package:flutter/material.dart';

import '../../../core/stores/task_store.dart';

import '../../../core/theme/app_colors.dart';
// import '../theme/app_theme.dart';

import '../widgets/task_row.dart';

/// Full page showing ONLY the tasks of one group ("Priority Tasks" or "Tasks").
class TaskListPage extends StatelessWidget {
  const TaskListPage({
    super.key, 
    required this.title, 
    required this.taskstore
  });

  final String title;
  
  final TaskStore taskstore;

  @override
  Widget build(BuildContext context) {
    // final isPriority = group == TaskGroup.priority;
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;
    // final accent = colorScheme.warningText;

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
              child: Text('No tasks here yet', style: TextStyle(color: colorScheme.onSurfaceVariant)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                color: tasks[i].isCompleted
                      ? customColors.successTint
                      : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TaskRow(task: tasks[i], onToggle: () => taskstore.toggle(tasks[i].id), taskstore: taskstore,),
            ),
          );
        },
      ),
    );
  }
}