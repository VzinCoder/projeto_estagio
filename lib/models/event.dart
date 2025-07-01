class Event {
  int? id;
  String type;
  String date;
  String observation;
  int petId;

  Event({
    this.id,
    required this.type,
    required this.date,
    required this.observation,
    required this.petId,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      type: map['type'],
      date: map['date'],
      observation: map['observation'],
      petId: map['animal_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "date": date,
      "observation": observation,
      "animal_id": petId,
    };
  }

  @override
  String toString() {
    return 'Event {id: $id, type: $type, date: $date, observation: $observation, petId: $petId}';
  }
}
