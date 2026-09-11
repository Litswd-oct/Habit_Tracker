import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository;
  List<Habit> _habits = [];

  HabitProvider(this._repository) {
    loadHabits();
  }

  List<Habit> get habits => _habits;

  Future<void> loadHabits() async {
    _habits = await _repository.getHabits();
    notifyListeners();
  }

  Future<void> addHabit({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    required int targetPerDay,
  }) async {
    final newHabit = Habit(
      id: const Uuid().v4(),
      name: name,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      targetPerDay: targetPerDay,
    );
    _habits.add(newHabit);
    await _repository.saveHabits(_habits);
    notifyListeners();
  }

  Future<void> markCompletion(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    final currentCount = habit.completions[dateStr] ?? 0;
    
    if (currentCount < habit.targetPerDay) {
      final newCompletions = Map<String, int>.from(habit.completions);
      newCompletions[dateStr] = currentCount + 1;
      
      _habits[index] = habit.copyWith(completions: newCompletions);
      await _repository.saveHabits(_habits);
      notifyListeners();
    }
  }

  Future<void> removeCompletion(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    final currentCount = habit.completions[dateStr] ?? 0;
    
    if (currentCount > 0) {
      final newCompletions = Map<String, int>.from(habit.completions);
      newCompletions[dateStr] = currentCount - 1;
      
      _habits[index] = habit.copyWith(completions: newCompletions);
      await _repository.saveHabits(_habits);
      notifyListeners();
    }
  }

  double getWeeklyProgress() {
    if (_habits.isEmpty) return 0.0;

    final today = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    int totalTargets = 0;
    int totalCompletions = 0;

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final dateStr = formatter.format(date);

      for (var habit in _habits) {
        totalTargets += habit.targetPerDay;
        totalCompletions += habit.completions[dateStr] ?? 0;
      }
    }

    if (totalTargets == 0) return 0.0;
    return totalCompletions / totalTargets;
  }
}
