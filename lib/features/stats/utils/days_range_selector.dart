import 'package:flutter/material.dart';
import '../../../core/theme/app_theme3.dart';

class DaysRangeSelector extends StatelessWidget {
  const DaysRangeSelector({
    super.key,
    required this.days,
    required this.onChanged,
  });

  static const presets = [7, 15, 30, 60, 90, 180, 365];
  static const maxDays = 3650;

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 15, color: Colors.white70);

    return Row(
      children: [
        const Text('Last ', style: textStyle),
        SizedBox(
          width: 72,
          child: RawAutocomplete<String>(
            initialValue: TextEditingValue(text: '$days'),
            // Always offer every preset, so the list shows when tapped
            optionsBuilder: (_) => presets.map((e) => '$e'),
            onSelected: (v) => onChanged(int.parse(v)),
            fieldViewBuilder: (context, controller, focusNode, _) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.peach,
                ),
                cursorColor: AppColors.peach,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFF292326),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  suffixIcon: const Icon(Icons.arrow_drop_down,
                      color: Colors.white54, size: 18),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () => controller.selection = TextSelection(
                    baseOffset: 0, extentOffset: controller.text.length),
                onChanged: (text) {
                  final n = int.tryParse(text);
                  if (n != null && n >= 1 && n <= maxDays) onChanged(n);
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: const Color(0xFF292326),
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: options.map((o) {
                        final selected = o == '$days';
                        return InkWell(
                          onTap: () => onSelected(o),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                o,
                                style: TextStyle(
                                  color: selected
                                      ? AppColors.peach
                                      : Colors.white70,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Text(' days', style: textStyle),
      ],
    );
  }
}