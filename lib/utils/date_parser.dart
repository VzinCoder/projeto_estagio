class DateParser {
  static DateTime? parseDate(String dateString){
    if(!isValidFormat(dateString)) return null;

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

  static bool isValidFormat(String dateString){
    var dateStringParts = dateString.split("/");
    if(dateStringParts.length != 3) return false;

    var dateParts = dateStringParts.map((part)=> int.tryParse(part)).toList();

    int? day = dateParts[0];
    int? month = dateParts[1];
    int? year = dateParts[2];

    try{
      var date = DateTime(year!, month!, day!);
      return date.day == day && date.month == month && date.year == year;
    }catch(_){
      return false;
    }
  }

  static String formatDate(DateTime date){
    String day = date.day.toString().padLeft(2,"0");
    String month = date.month.toString().padLeft(2,"0");
    String year = date.year.toString();

    return "$day/$month/$year";
  }
  static String formatDateISO8601(DateTime date){
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, "0");
    String day = date.day.toString().padLeft(2, "0");

    return "$year-$month-$day";
  }
}