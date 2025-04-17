import 'package:fitness_tracker/models/exercicie_model.dart';

class Day {
  final int? id;
  final String name;
  final List<Exercicie> exercicies;

  Day({this.id, required this.name, required this.exercicies});
}
