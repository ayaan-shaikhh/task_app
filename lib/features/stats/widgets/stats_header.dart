
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme3.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.calendarGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stats',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your progress at a glance',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
