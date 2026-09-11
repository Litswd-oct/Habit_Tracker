import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';

class WeeklyProgressIndicator extends StatelessWidget {
  const WeeklyProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final progress = provider.getWeeklyProgress();
        final percentage = (progress * 100).toInt();

        return Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Прогресс за неделю: $percentage%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 12.0,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
