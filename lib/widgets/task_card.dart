// import 'package:flutter/material.dart';

// import '../../models/task.dart';
// import '../../pages/task_list_page.dart';

// /// A home-page card: a tappable title on top and a scrollable preview of tasks below.
// class TaskCard extends StatelessWidget {
//   const TaskCard({super.key, required this.title, required this.tasks});

//   final String title;
//   final List<Task> tasks;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Only this header is tappable: it opens the full page for this card.
//           InkWell(
//             onTap: () => Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => TaskListPage(title: title, tasks: tasks),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ),
//                   const Icon(Icons.chevron_right),
//                 ],
//               ),
//             ),
//           ),
//           const Divider(height: 1),
//           Expanded(
//             child: tasks.isEmpty
//                 ? const Center(child: Text('No tasks'))
//                 : ListView.builder(
//                     itemCount: tasks.length,
//                     itemBuilder: (_, i) => _TaskTile(task: tasks[i]),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TaskTile extends StatelessWidget {
//   const _TaskTile({required this.task});
//   final Task task;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: true,
//       leading: Icon(
//         task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
//       ),
//       title: Text(
//         task.title,
//         style: task.completed
//             ? const TextStyle(decoration: TextDecoration.lineThrough)
//             : null,
//       ),
//     );
//   }
// }