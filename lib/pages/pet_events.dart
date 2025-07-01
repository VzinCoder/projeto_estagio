import 'package:flutter/material.dart';
import 'package:projeto_estagio/pages/add_pet_event.dart';
import '../utils/db.dart';
import '../repositories/event_repository.dart';
import '../models/event.dart';
import 'package:sqflite/sqflite.dart';
import '../my_app_routes.dart';
import '../pages/event_details.dart';

class PetEvents extends StatefulWidget {
  final int petId;
  const PetEvents({super.key, required this.petId});

  @override
  State<PetEvents> createState() => _PetEventsState();
}

class _PetEventsState extends State<PetEvents> {
  Future<EventRepository> _initRepository() async {
    Db instance = Db();
    Database database = await instance.database;
    EventRepository repository = EventRepository(database);
    return repository;
  }

  Future<List<Event>> _getAllEvents() async {
    EventRepository repository = await _initRepository();
    List<Event> allEvents = await repository.getAllEvents();
    return allEvents.where((event) => event.petId == widget.petId).toList();
  }

  Future<int> _deleteEvent(int id) async {
    EventRepository repository = await _initRepository();
    return await repository.deleteEvent(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos do Pet", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Event>>(
        future: _getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Event> events = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetails(event: event),
                      ),
                    );
                    setState(() {});
                  },
                  child: Card(
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
                                Text(
                                  event.type,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "📅 ${event.date}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Obs: ${event.observation}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddPetEvent(event: event),
                                    ),
                                  );
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.purple,
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  if (event.id != null) {
                                    await _deleteEvent(event.id!);
                                    setState(() {});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Evento inválido, não pode ser deletado',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar eventos: ${snapshot.error}"),
            );
          } else {
            return const Center(child: Text("Carregando eventos..."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPetEvent(petId: widget.petId!),
            ),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
