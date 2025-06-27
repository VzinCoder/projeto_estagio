import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/event.dart';
import 'package:projeto_estagio/pages/add_pet_event.dart';
import 'package:flutter/widgets.dart';
import "../my_app_routes.dart";

class PetEvents extends StatelessWidget {
  const PetEvents({super.key});

  Future<List<Event>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Event(
        id: 1,
        type: '🧪 Antirrábica muito muito muito muito muito muito longa',
        date: '12/03/2024',
        observation: '12/03/2025',
        petId: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos do Pet", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyAppRoutes.addPetEvent.routeName);
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FutureBuilder<List<Event>>(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum evento encontrado.'));
            }
            return EventList(events: snapshot.data!);
          },
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final List<Event> events;
  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCardItem(
          type: event.type,
          date: '📅 ${event.date}',
          observation: '📝 ${event.observation}',
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddPetEvent(event: event)),
          ),
          onDelete: () {},
        );
      },
    );
  }
}

class EventCardItem extends StatelessWidget {
  final String type;
  final String date;
  final String observation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCardItem({
    super.key,
    required this.type,
    required this.date,
    required this.observation,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, overflow: TextOverflow.ellipsis),
                  Text(observation, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Icon(Icons.edit, size: 20),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}