
import 'package:flutter/material.dart';

import '../core/stores/task_store.dart';
import '../core/stores/habit_store.dart';
import '../features/tasks/widgets/add_task_sheet.dart';
import '../features/home/home_page.dart';

// import 'placeholder_page.dart';

import '../features/calender/pages/calender.dart';

import '../features/settings/pages/settings_page.dart';
import '../features/stats/pages/stats_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final TaskStore taskStore = TaskStore();
  final HabitStore habitStore = HabitStore();

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      taskStore.loadTasks(),
      habitStore.loadHabits(),
    ]);
  }

  @override
  void dispose() {
    taskStore.dispose();
    habitStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(
            taskstore: taskStore,
            habitstore: habitStore,
          ),
          CalendarPage(
            taskstore: taskStore,
            habitstore: habitStore,
          ),
          StatsPage(
            taskstore: taskStore,
            habitstore: habitStore,
          ),
          const SettingsPage(),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              tooltip: 'Add task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskSheet(taskstore: taskStore, habitstore: habitStore),
                  ),
                );
              },
              child: const Icon(Icons.add, size: 30),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available_outlined),
            selectedIcon: Icon(Icons.event_available),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
