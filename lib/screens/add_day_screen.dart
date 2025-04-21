import 'package:fitness_tracker/components/fitness_tracker_input_form_field.dart';
import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/day_model.dart';
import 'package:fitness_tracker/repositories/day_repository.dart';
import 'package:flutter/material.dart';

class AddDayPage extends StatefulWidget {
  const AddDayPage({super.key});

  @override
  State<AddDayPage> createState() => _AddDayPageState();
}

class _AddDayPageState extends State<AddDayPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dayRepository = getIt<DayRepository>();

  Future _saveDay() async {
    if (_formKey.currentState!.validate()) {
      final newDay = Day(name: _nameController.text, exercicies: []);
      await _dayRepository.insertDay(newDay);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Dia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              FitnessTrackerInputFormField(
                controller: _nameController,
                label: 'Nome do Dia',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Digite um nome'
                            : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDay,
                child: const Text('Salvar Dia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
