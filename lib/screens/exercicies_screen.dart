import 'package:fitness_tracker/components/fitness_tracker_card.dart';
import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/services/exercicies_service.dart';
import 'package:fitness_tracker/services/vibration_service.dart';
import 'package:flutter/material.dart';

class ExerciciesScreen extends StatefulWidget {
  const ExerciciesScreen({super.key});

  @override
  State<ExerciciesScreen> createState() => _ExerciciesScreenState();
}

class _ExerciciesScreenState extends State<ExerciciesScreen> {
  @override
  Widget build(BuildContext context) {
    final exercicioService = getIt<ExerciciesService>();
    final day = ModalRoute.of(context)!.settings.arguments as Day;

    return Scaffold(
      appBar: AppBar(title: Text(day.name)),
      body: FutureBuilder(
        future: exercicioService.getDaysExercicies(day.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final exercicies = snapshot.data!;
          return ListView.builder(
            itemCount: exercicies.length,
            itemBuilder: (context, index) {
              final exercicie = exercicies[index];
              return FitnessTrackerCard(
                child: ListTile(
                  title: Text(exercicie.name),
                  subtitle: Text('${exercicie.repetition} repetições'),
                  trailing: IconButton(
                    onPressed: () {
                      getIt<VibrationService>().vibrate();
                    },
                    icon: Icon(Icons.play_arrow),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
