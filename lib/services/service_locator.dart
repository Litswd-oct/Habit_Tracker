import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/habit_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<HabitRepository>(
    () => SharedPreferencesHabitRepository(getIt<SharedPreferences>()),
  );
}
