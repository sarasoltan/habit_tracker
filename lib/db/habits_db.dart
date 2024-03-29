import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project2/db/days_table.dart';
import 'package:project2/db/habits_days_table.dart';
import 'package:project2/db/habits_table.dart';
import 'package:project2/db/users_table.dart';
import 'package:project2/extensions/list/filter.dart';
import 'package:project2/models/habit.dart';
import 'package:project2/models/user.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/services/crud/crud_exceptions.dart';
import 'package:project2/services/data_service.dart';
import 'package:project2/services/data_service.dart';
import 'package:sqflite/sqflite.dart';

class HabitsDb {
  static Users? _user;
  static const String dbName = "habits.db";

  static Future<Database> connectToDb() async {
    Future _onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    return await openDatabase(dbName,
        version: 1, onCreate: _createTables, onConfigure: _onConfigure);
    //return await openDatabase(dbName, onConfigure: _onConfigure);
  }

  final dataService = DataService;

  static Future<void> _createTables(Database db, int version) async {
    await db.execute(HabitsTable.createQuery);
    await db.execute(UsersTable.createQuery);
    await db.execute(DaysTable.createQuery);
    await db.execute(HabitsDaysTable.createQuery);

    //   await _createTutorialHabit(db);
  }

  // static Future<void> _createTutorialHabit(Database db) async {
  //   db.insert(HabitsTable.tableName, {
  //     HabitsTable.text: "Add habits ↗️",
  //     HabitsTable.emoji: "✔️",
  //     HabitsTable.period: "[1, 2, 3, 4, 5, 6, 7]"
  //   });
  // }

  static Future<List<Map<String, dynamic>>> getAllHabits(
    Database db,
  ) {
    // final user = AuthService.firebase().currentUser;
    // final currentUser = _user;
    return db.query(
      HabitsTable.tableName,
      // where: "${HabitsTable.userId} = ?",
      // whereArgs: [currentUser?.id],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllDays(Database db) {
    return db.query(DaysTable.tableName);
  }

  static Future<List<Map<String, dynamic>>> getDaysByYear(
      Database db, int year) {
    final from = DateTime(year, 1);
    final to = DateTime(year, 12);

    return db.query(DaysTable.tableName,
        where: "${DaysTable.date} >= ? AND ${DaysTable.date} <= ?",
        whereArgs: [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch]);
  }

  static Future<List<Map<String, dynamic>>> getDaysByMonth(Database db,
      {required int year, required int month}) {
    return db.query(DaysTable.tableName,
        where: "${DaysTable.date} >= ? AND ${DaysTable.date} <= ?",
        whereArgs: [
          DateTime(year, month).millisecondsSinceEpoch,
          DateTime(year, month, DateUtils.getDaysInMonth(year, month))
              .millisecondsSinceEpoch
        ]);
  }

  static Future<List<Map<String, dynamic>>> getHabitsDaysByDay(Database db,
      {required Map<String, dynamic> day}) {
    return db.query(HabitsDaysTable.tableName,
        where: "${HabitsDaysTable.dayId} = ?",
        whereArgs: [day[DaysTable.date]]);
  }

  // static Future<int> createHabit(Database db, Habit habit) async {
  static Future<int> createHabit(Database db, Habit habit) {
    return db.insert(HabitsTable.tableName, habit.toDb(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> deleteHabit(Database db, int habitId) {
    return db.delete(HabitsTable.tableName,
        where: "${HabitsTable.id} = ?", whereArgs: [habitId]);
  }

  static Future<int> updateHabit(Database db, Habit habit) async {
    return db.update(HabitsTable.tableName, await habit.toDb(),
        where: "${HabitsTable.id} = ?", whereArgs: [habit.id]);
  }

  static Future<int> deleteHabitsDays(Database db, int habitId) {
    return db.delete(HabitsDaysTable.tableName,
        where: "${HabitsDaysTable.habitId} = ?", whereArgs: [habitId]);
  }

  static Future<int> createDay(Database db, {required DateTime date}) {
    return db.insert(
        DaysTable.tableName, {DaysTable.date: date.millisecondsSinceEpoch},
        //This will ignore same entries
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<int> createHabitDay(Database db, int dayId, int habitId) {
    return db.insert(
        HabitsDaysTable.tableName,
        {
          HabitsDaysTable.dayId: dayId,
          HabitsDaysTable.habitId: habitId,
          HabitsDaysTable.done: 0
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> updateHabitDayDone(
      Database db, DateTime date, int habitId, bool newValue) {
    return db.update(
        HabitsDaysTable.tableName, {HabitsDaysTable.done: newValue ? 1 : 0},
        where:
            "${HabitsDaysTable.dayId} = ? AND ${HabitsDaysTable.habitId} = ?",
        whereArgs: [date.millisecondsSinceEpoch, habitId]);
  }
/////////////////////////////////

}
