import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/exercicie_model.dart';
import 'package:fitness_tracker/repositories/day_repository.dart';

class ExerciciesService {
  final _dayRepository = getIt<DayRepository>();

  Future<List<Exercicie>> getDaysExercicies(int dayId) async {
    final days = await _dayRepository.getDayById(dayId);
    return days == null ? [] : days.exercicies;
  }
}
