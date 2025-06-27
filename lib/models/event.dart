class Event {
  int? id;
  String type;
  String date;
  String observation;
  int pet_id;

  Event({
    this.id,
    required this.type,
    required this.date,
    required this.observation,
    required this.pet_id,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      type: map['type'],
      date: map['date'],
      observation: map['observation'],
      pet_id: map['pet_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "date": date,
      "observation": observation,
      "pet_id": pet_id,
    };
  }

  @override
  String toString() {
    return 'Event {id: $id, type: $type, date: $date, observation: $observation, petId: $pet_id}';
  }
}
