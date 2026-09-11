import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/habit.dart';
import '../../providers/habit_provider.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final currentCount = habit.completions[todayStr] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(habit.colorValue),
            child: Icon(
              IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: Colors.white,
            ),
          ),
          title: Text(habit.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('$currentCount / ${habit.targetPerDay} сегодня'),
          trailing: Wrap(
            spacing: -8.0,
            children: List.generate(habit.targetPerDay, (index) {
              final isCompleted = index < currentCount;
              return IconButton(
                icon: Icon(
                  isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isCompleted ? Color(habit.colorValue) : Colors.grey,
                ),
                onPressed: () {
                  final provider = context.read<HabitProvider>();
                  if (isCompleted) {
                    if (index == currentCount - 1) {
                      provider.removeCompletion(habit.id, DateTime.now());
                    }
                  } else {
                    if (index == currentCount) {
                      provider.markCompletion(habit.id, DateTime.now());
                    }
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
