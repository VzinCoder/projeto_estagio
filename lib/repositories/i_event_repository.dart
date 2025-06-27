import 'package:projeto_estagio/models/event.dart';

abstract class IEventRepository {
  Future<int> insertEvent(Event event);
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(int id);
  Future<int> updateEvent(Event event);
  Future<int> deleteEvent(int id);
  Future<List<Event>> getEventsByPetId(int petId);
}