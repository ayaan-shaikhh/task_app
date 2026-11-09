import 'package:flutter/material.dart';
import '../../../core/theme/app_theme3.dart';

class StatsTabSelector extends StatelessWidget {
  const StatsTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const labels = ['Tasks', 'Habits'];

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF292326),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.peach : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.white70,
                  ),
                  child: Text(labels[i]),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}