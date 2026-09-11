import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/weekly_progress_indicator.dart';
import '../widgets/add_habit_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddHabitSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер Привычек'),
        centerTitle: true,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          if (provider.habits.isEmpty) {
            return const Center(
              child: Text('Пока нет привычек. Добавьте первую!'),
            );
          }

          return ListView(
            children: [
              const WeeklyProgressIndicator(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Привычки на сегодня',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...provider.habits.map((habit) => HabitCard(habit: habit)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }
}
