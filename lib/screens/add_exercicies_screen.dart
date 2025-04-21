import 'package:fitness_tracker/components/fitness_tracker_input_form_field.dart';
import 'package:fitness_tracker/configs/get_it_configurator.dart';
import 'package:fitness_tracker/models/exercicie_model.dart';
import 'package:fitness_tracker/repositories/exercise_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExercicieScreen extends StatefulWidget {
  const AddExercicieScreen({super.key});

  @override
  State<AddExercicieScreen> createState() => _AddExercicieScreenState();
}

class _AddExercicieScreenState extends State<AddExercicieScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repetitionController = TextEditingController();
  final _intervalController = TextEditingController();

  Future _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newExercicie = Exercicie(
        name: _nameController.text,
        description: _descriptionController.text,
        repetition: int.parse(_repetitionController.text),
        interval: int.parse(_intervalController.text),
      );

      await getIt<ExerciseRepository>().insertExercicie(newExercicie);

      _formKey.currentState!.reset();
      _nameController.clear();
      _descriptionController.clear();
      _repetitionController.clear();
      _intervalController.clear();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _repetitionController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              FitnessTrackerInputFormField(
                controller: _nameController,
                label: 'Nome',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o nome'
                            : null,
              ),
              FitnessTrackerInputFormField(
                controller: _descriptionController,
                label: 'Descrição',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe a descrição'
                            : null,
              ),
              FitnessTrackerInputFormField(
                controller: _repetitionController,
                label: 'Repetições',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o número de repetições';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              FitnessTrackerInputFormField(
                controller: _intervalController,
                label: 'Intervalo (segundos)',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o intervalo';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
