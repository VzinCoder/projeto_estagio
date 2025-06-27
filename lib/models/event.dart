class Event {
  int? id;
  String type;
  String date;
  String observation;

  Event({
    this.id,
    required this.type,
    required this.date,
    required this.observation,
  });

  Event.fromMap(Map<String, dynamic> map): 
    id = map['id'], 
    type = map['type'], 
    date = map['date'], 
    observation = map['observation'];
  


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "date": date,
      "observation": observation,
    };
  }

  @override
  String toString() {
    return 'Event {id: $id, type: $type, date: $date, observation: $observation}';
  }
}
