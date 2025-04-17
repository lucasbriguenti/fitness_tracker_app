import 'package:fitness_tracker/components/fitness_tracker_card.dart';
import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/repositories/day_repository.dart';
import 'package:fitness_tracker/services/day_service.dart';
import 'package:flutter/material.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({super.key});

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  final daysService = getIt<DayService>();
  late Future<List<Day>> _futureDays;

  @override
  void initState() {
    super.initState();
    _carregarDias();
  }

  void _carregarDias() {
    _futureDays = daysService.getDays();
  }

  Future<void> _irParaTelaAddDay() async {
    await Navigator.pushNamed(context, '/add-days');
    setState(() {
      _carregarDias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dias')),
      floatingActionButton: FloatingActionButton(
        onPressed: _irParaTelaAddDay,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Day>>(
        future: _futureDays,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erro ao carregar os dias'));
          }

          final days = snapshot.data!;
          return ListView.builder(
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              return FitnessTrackerCard(
                child: ListTile(
                  title: Text(day.name),
                  onTap: () {
                    Navigator.pushNamed(context, '/exercicies', arguments: day);
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(day.name),
                            content: const Text('O que você deseja fazer?'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // ação 1, por exemplo: editar
                                },
                                child: const Text('Exercícios'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await getIt<DayRepository>().deleteDay(
                                    day.id!,
                                  );
                                  setState(() {
                                    _carregarDias();
                                  });
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                    );
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
