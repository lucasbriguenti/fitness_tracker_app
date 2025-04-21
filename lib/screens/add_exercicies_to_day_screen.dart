import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/models/exercicie_model.dart';
import 'package:fitness_tracker/repositories/day_repository.dart';
import 'package:fitness_tracker/repositories/exercise_repository.dart';
import 'package:flutter/material.dart';

class AddExerciciesToDayScreen extends StatefulWidget {
  const AddExerciciesToDayScreen({super.key});

  @override
  State<AddExerciciesToDayScreen> createState() =>
      _AddExerciciesToDayScreenState();
}

class _AddExerciciesToDayScreenState extends State<AddExerciciesToDayScreen> {
  late Future<List<Exercicie>> futureExercicios;
  List<Exercicie> exerciciosSelecionados = [];

  void carregarExercicies() {
    futureExercicios = getIt<ExerciseRepository>().getAllExercicies();
  }

  @override
  void initState() {
    super.initState();
    carregarExercicies();
  }

  void saveExercicies(Day day) async {
    if (exerciciosSelecionados.isEmpty) return;

    await getIt<DayRepository>().insertExerciciesDays(
      day.id!,
      exerciciosSelecionados.map((x) => x.id!).toList(),
    );
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = ModalRoute.of(context)!.settings.arguments as Day;

    return Scaffold(
      appBar: AppBar(title: Text(day.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-exercicie');
          setState(() {
            carregarExercicies();
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Exercicie>>(
        future: futureExercicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar os exercicios'));
          }

          final exericicies = snapshot.data!;

          return ListView.builder(
            itemCount: exericicies.length + 1,
            itemBuilder: (context, index) {
              if (index == exericicies.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: ElevatedButton(
                    onPressed: () => saveExercicies(day),
                    child: Text('Salvar'),
                  ),
                );
              }

              final exericicie = exericicies[index];
              return ListTile(
                title: Text(exericicie.name),
                subtitle: Text(exericicie.description),
                trailing: Checkbox(
                  value: exerciciosSelecionados.contains(exericicie),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        exerciciosSelecionados.add(exericicie);
                      } else {
                        exerciciosSelecionados.remove(exericicie);
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
