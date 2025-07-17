import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/models/vaccine.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/injector.dart';

class AddPetVaccine extends StatefulWidget {
  final Vaccine? vaccine;
  final Pet? pet;
  const AddPetVaccine({super.key, this.pet, this.vaccine});

  @override
  State<AddPetVaccine> createState() => _AddPetVaccineState();
}

class _AddPetVaccineState extends State<AddPetVaccine> {
  final VaccineRepository vaccineRepository = getIt<VaccineRepository>();
  late final TextEditingController nameController;
  late final TextEditingController dateAplicationController;
  late final TextEditingController dateNextController;

  bool get isEditing => widget.vaccine != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.vaccine?.name ?? '');
    dateAplicationController = TextEditingController(
      text: widget.vaccine?.dateApplication ?? '',
    );
    dateNextController = TextEditingController(
      text: widget.vaccine?.nextDateApplication ?? '',
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final dayFormatted = date.day.toString().padLeft(2, '0');
      final monthFormatted = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      controller.text = "$year-$monthFormatted-$dayFormatted";
    }
  }

  void save() async {
    final name = nameController.text;
    final dateApp = dateAplicationController.text;
    final nextDate = dateNextController.text == '' ? null: dateNextController.text;

    if (isEditing) {
      final updated = widget.vaccine!;
      updated.name = name;
      updated.dateApplication = dateApp;
      updated.nextDateApplication = nextDate;

      await vaccineRepository.updateVaccine(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vacina atualizada com sucesso!')),
      );
      return Navigator.pop(context,updated);
    }

    final newVaccine = Vaccine(
      name: name,
      dateApplication: dateApp,
      nextDateApplication: nextDate,
      petId: widget.pet!.id!,
    );

    await vaccineRepository.insertVaccine(newVaccine);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Vacina salva com sucesso!')));
    Navigator.pop(context, newVaccine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Vacina' : 'Cadastrar Vacina',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateAplicationController,
              readOnly: true,
              onTap: () => _selectDate(dateAplicationController),
              decoration: const InputDecoration(
                labelText: 'Data de Aplicação',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateNextController,
              readOnly: true,
              onTap: () => _selectDate(dateNextController),
              decoration: const InputDecoration(
                labelText: 'Próxima Dose',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: save,
              child: Text(isEditing ? 'Atualizar' : 'Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
