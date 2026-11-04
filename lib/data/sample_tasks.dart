// import '../../models/task.dart';

// // Temporary in-memory data so the screens have something to show.
// // Replace this with real data (backend / database) later.
// const List<Task> sampleTasks = [
//   Task(title: 'Submit project report', isPriority: true),
//   Task(title: 'Pay electricity bill', isPriority: true),
//   Task(title: 'Call the bank', isPriority: true),
//   Task(title: 'Buy groceries'),
//   Task(title: 'Book dentist appointment'),
//   Task(title: 'Clean the desk'),
//   Task(title: 'Read 20 pages'),
//   Task(title: 'Reply to emails', completed: true),
// ];

import '../core/models/task.dart';
import '../core/models/habit_task.dart';

// Temporary in-memory sample data.
final List<Task> sampleTasks = [
  Task(
    id: 's1',
    title: 'Submit project report',
    deadline: DateTime.now().add(const Duration(hours: 1)),
  ),
  Task(
    id: 's2',
    title: 'Pay electricity bill',
    deadline: DateTime.now().add(const Duration(hours: 2)),
  ),
  Task(
    id: 's3',
    title: 'Call the bank',
    deadline: DateTime.now().add(const Duration(hours: 3)),
  ),
  Task(
    id: 's4',
    title: 'Buy groceries',
    deadline: DateTime.now().add(const Duration(hours: 5)),
  ),
  Task(
    id: 's5',
    title: 'Book dentist appointment',
    deadline: DateTime.now().add(const Duration(hours: 8)),
  ),
  Task(
    id: 's6',
    title: 'Clean the desk',
    deadline: DateTime.now().add(const Duration(hours: 12)),
  ),
  Task(
    id: 's7',
    title: 'Read 20 pages',
    deadline: DateTime.now().add(const Duration(days: 1)),
  ),
  Task(
    id: 's8',
    title: 'Reply to emails',
    deadline: DateTime.now().add(const Duration(days: 2)),
    isCompleted: true,
  ),
];

final List<HabitTask> sampleHabitTasks = [
  HabitTask(id: "1", title: "Gym"),
  HabitTask(id: "2", title: "Pashto"),
  HabitTask(id: "3", title: "Calisthenics"),
  HabitTask(id: "4", title: "Typing"),
  HabitTask(id: "5", title: "Quran"),
  HabitTask(id: "6", title: "Reading"),
  HabitTask(id: "7", title: "Namaz"),

];