import "package:flutter/material.dart";
import 'package:projeto_estagio/models/event.dart';

class AddPetEvent extends StatefulWidget {
  final Event? event;
  const AddPetEvent({super.key, this.event});

  @override
  State<AddPetEvent> createState() => _AddPetEventState();
}

class _AddPetEventState extends State<AddPetEvent> {
  late final TextEditingController nameController;
  late final TextEditingController dateController;
  late final TextEditingController descriptionController;

  bool get isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event?.type ?? '');
    dateController = TextEditingController(text: widget.event?.date ?? '');
    descriptionController = TextEditingController(
      text: widget.event?.observation ?? '',
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
      controller.text = "$dayFormatted/$monthFormatted/$year";
    }
  }

  void save() {
    final type = nameController.text;
    final date = dateController.text;
    final observation = descriptionController.text;

    if (isEditing) {
      final updated = widget.event!;
      updated.type = type;
      updated.date = date;
      updated.observation = observation;
    } else {
      final newEvent = Event(
        type: type,
        date: date,
        observation: observation,
        petId: 0,
      );

      print('Evento criado: $newEvent');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Evento ${isEditing ? 'atualizado' : 'criado'} com sucesso!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Evento' : 'Adicionar Evento'),
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
                labelText: 'Tipo de Evento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () => _selectDate(dateController),
              decoration: const InputDecoration(
                labelText: 'Data do Evento',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
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
