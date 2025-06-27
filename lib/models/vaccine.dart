class Vaccine {
  int? id;
  String name;
  String dateApplication;
  String nextDateApplication;
  int petId;

  Vaccine({
    this.id,
    required this.name,
    required this.dateApplication,
    required this.nextDateApplication,
    required this.petId,
  });

  DateTime? get dateApplicationDateTime => _parseDate(dateApplication);
  DateTime? get nextDateApplicationDateTime => _parseDate(nextDateApplication);

  set dateApplicationDateTime(DateTime? date) {
    if (date != null) {
      dateApplication = _formatDate(date);
    }
  }

  set nextDateApplicationDateTime(DateTime? date) {
    if (date != null) {
      nextDateApplication = _formatDate(date);
    }
  }

  DateTime? _parseDate(String dateString) {
    if (!_isValidDateFormat(dateString)) return null;
    try {
      final parts = dateString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return "$day/$month/$year";
  }

  bool _isValidDateFormat(String dateString) {
    final parts = dateString.split('/');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;

    try {
      final date = DateTime(year, month, day);
      return date.day == day && date.month == month && date.year == year;
    } catch (_) {
      return false;
    }
  }

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'],
      name: map['name'],
      dateApplication: map['application_date'],
      nextDateApplication: map['next_dose_date'],
      petId: map['animal_id'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'application_date': dateApplication,
      'next_dose_date': nextDateApplication,
      'animal_id': petId,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  @override
  String toString() {
    return 'Vaccine {id: $id, name: $name, dateApplication: $dateApplication, nextDateApplication: $nextDateApplication, petId: $petId}';
  }
}
