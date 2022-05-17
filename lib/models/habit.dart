import 'dart:convert';

import 'package:project2/db/habits_table.dart';
import 'package:project2/db/users_table.dart';
import 'package:project2/models/user.dart';

DatabaseUser? owner;

class Habit {
  late final int id;
  late final int userId;
  late String text;
  late String emoji;
  late final List<int> period;
  late final DateTime? startPeriod;

  Habit(
      {
      //required this.id,
      required this.userId,
      required this.text,
      required this.emoji,
      required this.period,
      this.startPeriod});

  Habit.fromDb(Map<String, dynamic> map) {
    id = map[HabitsTable.id] as int;
    userId = map[HabitsTable.userId] as int;
    text = map[HabitsTable.text] as String;
    emoji = map[HabitsTable.emoji];
    period = (jsonDecode(map[HabitsTable.period]) as List<dynamic>)
        .map((e) => e as int)
        .toList();
    if (map[HabitsTable.startPeriod] != null) {
      startPeriod =
          DateTime.fromMillisecondsSinceEpoch(map[HabitsTable.startPeriod]);
    } else {
      startPeriod = null;
    }
  }

  Map<String, dynamic> toDb() {
    return {
      HabitsTable.id: id,
      HabitsTable.userId: owner!.id,
      HabitsTable.text: text,
      HabitsTable.emoji: emoji,
      HabitsTable.period: jsonEncode(period),
      HabitsTable.startPeriod: startPeriod?.millisecondsSinceEpoch
    };
  }

  @override
  String toString() =>
      'Habit, ID = $id, userId = $userId, text = $text, emoji = $emoji , period=$period , startPeriod = $startPeriod ';

  @override
  bool operator ==(covariant Habit other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
