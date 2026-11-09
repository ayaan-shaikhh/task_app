import 'package:flutter/material.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/stores/habit_store.dart';
import '../widgets/tab_selector.dart';
import '../widgets/task_stats_body.dart';
import '../widgets/habit_stats_body.dart';

class StatsAppShell extends StatefulWidget {
  const StatsAppShell({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  final TaskStore taskstore;
  final HabitStore habitstore;

  @override
  State<StatsAppShell> createState() => _StatsAppShellState();
}

class _StatsAppShellState extends State<StatsAppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: StatsTabSelector(
            selectedIndex: _index,
            onChanged: (i) => setState(() => _index = i),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _index,
            children: [
              TaskStatsBody(taskstore: widget.taskstore),
              HabitStatsBody(habitstore: widget.habitstore),
            ],
          ),
        ),
      ],
    );
  }
}