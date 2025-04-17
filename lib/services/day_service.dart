import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/repositories/day_repository.dart';

class DayService {
  Future<List<Day>> getDays() {
    return getIt<DayRepository>().getAllDays();
  }
}
