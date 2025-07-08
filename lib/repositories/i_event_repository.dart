import 'package:projeto_estagio/models/event.dart';

abstract class IEventRepository {
  Future<int> insertEvent(Event event);
  Future<List<Event>> getAllEvents();
  Future<Event?> getEventById(String id);
  Future<int> updateEvent(Event event);
  Future<int> deleteEvent(String id);
  Future<List<Event>> getEventsByPetId(String petId);
}