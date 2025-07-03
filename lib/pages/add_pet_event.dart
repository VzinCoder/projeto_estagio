import "package:flutter/material.dart";
import "package:projeto_estagio/utils/injector.dart";
import "../utils/db.dart";
import "../repositories/event_repository.dart";
import "../models/event.dart";
import "package:sqflite/sqflite.dart";
import "../my_app_routes.dart";

class AddPetEvent extends StatefulWidget {
  final Event? event;
  final int? petId;

  const AddPetEvent({super.key, this.event, this.petId});

  @override
  State<AddPetEvent> createState() {
    return _AddPetEventState();
  }
}

class _AddPetEventState extends State<AddPetEvent> {
  late final TextEditingController nameController;
  late final TextEditingController dateController;
  late final TextEditingController descriptionController;
  late final int petId;

  late final bool isEditing;
  final EventRepository eventRepository = getIt<EventRepository>();

  Future<int> _addEvent() async {
    Event event = Event(
      type: nameController.text,
      date: dateController.text,
      observation: descriptionController.text,
      petId: petId,
    );

    int id = await eventRepository.insertEvent(event);
    return id;
  }

  Future<int> _updateEvent() async {
    Event event = Event(
      id: widget.event?.id ?? 0,
      type: nameController.text,
      date: dateController.text,
      observation: descriptionController.text,
      petId: petId,
    );

    return await eventRepository.updateEvent(event);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event?.type ?? '');
    dateController = TextEditingController(text: widget.event?.date ?? '');
    descriptionController = TextEditingController(
      text: widget.event?.observation ?? '',
    );

    isEditing = widget.event != null;
    petId = widget.event?.petId ?? widget.petId!;
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      controller.text = '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Evento' : 'Adicionar Evento',
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
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  if (isEditing) {
                    await _updateEvent();
                  } else {
                    await _addEvent();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEditing
                            ? 'Evento atualizado com sucesso!'
                            : "Evento salvo com sucesso!",
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  isEditing ? 'Atualizar Evento' : 'Adicionar Evento',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
