import 'package:flutter/material.dart';

TimeOfDay parseTimeOfDay(String value) {
  if (value != null) {
    var times = value.split(":");
    if (times.length == 2)
      return TimeOfDay(hour: int.parse(times[0]), minute: int.parse(times[1]));
  }

  return TimeOfDay(hour: 12, minute: 0);
}

enum DayType { Clear, Check, Fail, Skip }

List<String> months = [
  "",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class HaboColors {
  static final Color primary = Color(0xFF09BF30);
  static final Color red = Colors.red;
  static final Color skip = Color(0xFF818181); //0xFF505050
  static final Color comment = Colors.orange;
  static final Color orange = Colors.orange;
}
