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
    String hour = date.hour.toString().padLeft(2, "0");
    String minute = date.minute.toString().padLeft(2, "0");
    String second = date.second.toString().padLeft(2, "0");

    return "$year-$month-$day\T$hour:$minute:$second\Z";
  }

  static DateTime decodeDateISO8601(String date){
  // pegar só data e hora
    var list1 = date.split("Z");
    var list2 = list1[0].split(".");
    
    var dateAndHour = list2[0].split("T");
    var dataParts = dateAndHour[0].split("-"); // decodificando a data
    var hourParts = dateAndHour[1].split(":"); //decodificando as horas

    int year = int.parse(dataParts[0]);
    int month = int.parse(dataParts[1]);
    int day = int.parse(dataParts[2]);
    int hour = int.parse(hourParts[0]);
    int minute = int.parse(hourParts[1]);
    int second = int.parse(hourParts[2]);

    return DateTime(year, month, day, hour, minute, second);
  }

  static bool isAfterDate(String date1, String date2){
    DateTime firstDate = DateParser.decodeDateISO8601(date1);
    DateTime secondDate = DateParser.decodeDateISO8601(date2);
    
    return firstDate.isAfter(secondDate);
  }
}