import 'package:flutter/material.dart';

import '../models/task.dart';
// import '../theme/app_theme.dart';
import 'task_row.dart';

import '../data/task_store.dart';

/// A tinted home-page card: icon badge + title + subtitle, a short preview of tasks,
/// and a "View all" link. Tapping the header (or "View all") calls [onOpen].
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.accentText,
    required this.tint,
    required this.border,
    required this.tasks,
    required this.onOpen,
    required this.onToggle,
    required this.taskstore,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent; // badge colour
  final Color accentText; // chevron and "View all" colour
  final Color tint; // card background
  final Color border;
  final List<Task> tasks;
  final VoidCallback onOpen;
  final TaskStore taskstore;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    final preview = tasks.toList();
    final colorScheme = Theme.of(context).colorScheme;

    // Material (not Container) so the tap ripple on the header is visible on the tinted background.
    return Material(
      color: tint,
      elevation: 2,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant,)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: accentText),
                ],
              ),
            ),
          ),
          Expanded(
            child: preview.isEmpty
                ? Center(
                    child: Text('Nothing here yet', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  )
                : ListView(
                    padding: const EdgeInsets.only(top: 4),
                    children: [for (final t in preview) TaskRow(task: t, onToggle: () => onToggle(t.id),taskstore: taskstore,)],
                  ),
          ),
          InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                'View all (${tasks.length})',
                style: TextStyle(color: accentText, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}