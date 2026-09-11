import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> saveHabits(List<Habit> habits);
}

class SharedPreferencesHabitRepository implements HabitRepository {
  static const String _storageKey = 'habits_data';
  final SharedPreferences _prefs;

  SharedPreferencesHabitRepository(this._prefs);

  @override
  Future<List<Habit>> getHabits() async {
    final String? habitsJson = _prefs.getString(_storageKey);
    if (habitsJson == null) {
      return [];
    }
    
    final List<dynamic> decoded = json.decode(habitsJson);
    return decoded.map((item) => Habit.fromMap(item)).toList();
  }

  @override
  Future<void> saveHabits(List<Habit> habits) async {
    final String habitsJson = json.encode(habits.map((h) => h.toMap()).toList());
    await _prefs.setString(_storageKey, habitsJson);
  }
}
