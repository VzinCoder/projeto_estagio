import 'package:sqflite/sqflite.dart';
import 'package:projeto_estagio/models/event.dart';
import 'package:projeto_estagio/repositories/i_event_repository.dart';

class EventRepository implements IEventRepository {
  final Database db;

  EventRepository(this.db);

  @override
  Future<int> deleteEvent(int id) {
    return db.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Event>> getAllEvents() async {
    final result = await db.query('events');
    return result.map((map) => Event.fromMap(map)).toList();
  }

  @override
  Future<Event?> getEventById(int id) async {
    final result = await db.query('events', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return Event.fromMap(result.first);
  }

  @override
  Future<int> insertEvent(Event event) {
    return db.insert('events', event.toMap());
  }

  @override
  Future<int> updateEvent(Event event) {
    if (event.id == null) {
      throw Exception("Cannot update event without ID");
    }
    return db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  @override
  Future<List<Event>> getEventsByPetId(int petId) async {
    final result = await db.query(
      'events',
      where: 'pet_id = ?',
      whereArgs: [petId],
    );
    return result.map((map) => Event.fromMap(map)).toList();
  }
}
