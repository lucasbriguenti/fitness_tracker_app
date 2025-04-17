import 'package:fitness_tracker/repositories/day_repository.dart';
import 'package:fitness_tracker/repositories/exercise_repository.dart';
import 'package:fitness_tracker/services/day_service.dart';
import 'package:fitness_tracker/services/exercicies_service.dart';
import 'package:fitness_tracker/services/vibration_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => VibrationService());
  getIt.registerLazySingleton(() => DayService());
  getIt.registerLazySingleton(() => ExerciciesService());
  getIt.registerLazySingleton(() => ExerciseRepository());
  getIt.registerLazySingleton(() => DayRepository());
}
