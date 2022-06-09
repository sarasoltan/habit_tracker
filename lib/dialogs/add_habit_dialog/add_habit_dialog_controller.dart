import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:project2/db/user_services.dart';
import 'package:project2/extensions/list/filter.dart';
import 'package:project2/models/habit.dart';
import 'package:project2/models/user.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/services/data_service.dart';
import 'package:sqflite/sqflite.dart';

class AddHabitDialogController {
  Users? owner;
  Users? _user;

  //final user = FirebaseAuth.instance.currentUser;
  //String get owneruserId => AuthService.firebase().currentUser!.id;
  final DataService userService = DataService();
//String get owneruserId => AuthService.firebase().currentUser!.id;
  String get owneremail => AuthService.firebase().currentUser!.email;
//Users owner = Users(email: owneremail);
  Future<Users> s() async {
    final owner = await userService.getUser(email: owneremail);
    return owner;
  }

  final List<bool> period = [true, true, true, true, true, true, true];
  int? id;
  int? userId;
  String? emoji;
  String? text;
  StartPeriod startPeriod = StartPeriod.none;

  final StreamController<bool> _addBtnEnabledCtrl = StreamController();
  Stream<bool> get addBtnEnabled => _addBtnEnabledCtrl.stream;

  final StreamController<StartPeriod> _selectedStartPeriodCtrl =
      StreamController();
  Stream<StartPeriod> get selectedStartPeriod =>
      _selectedStartPeriodCtrl.stream;

  final StreamController<bool> _loadingCtrl = StreamController();
  Stream<bool> get loading => _loadingCtrl.stream;

  void changePeriodValue(int index, bool newValue) {
    period[index] = newValue;
    _updateAddBtnEnabledState();
  }

  void changeTextValue(String newValue) {
    text = newValue;
    _updateAddBtnEnabledState();
  }

  void changeEmojiValue(String newEmoji) {
    emoji = newEmoji;
    _updateAddBtnEnabledState();
  }

  void changeStartPeriod(StartPeriod newValue) {
    startPeriod = newValue;
    _selectedStartPeriodCtrl.add(startPeriod);
  }

  Future<void> addHabit(BuildContext context) async {
    _loadingCtrl.add(true);
    final dataService = GetIt.I.get<DataService>();

    final List<int> forPeriod = [];
    for (int i = 0; i < period.length; i++) {
      if (period[i]) {
        forPeriod.add(i + 1);
      }
    }
    Users a = await s();

    final habit = Habit(
        //id: id!,
        userId: a.id,
        emoji: emoji!,
        text: text!,
        period: forPeriod,
        startPeriod: _calculateStartPeriodDateTime());
    await dataService.addHabit(habit);
    _loadingCtrl.add(false);
    Navigator.of(context).pop();
  }

  void _updateAddBtnEnabledState() {
    _addBtnEnabledCtrl.add((text?.isNotEmpty ?? false) &&
        (emoji?.isNotEmpty ?? false) &&
        period.where((e) => e).isNotEmpty);
  }

  DateTime? _calculateStartPeriodDateTime() {
    final now = DateTime.now();

    switch (startPeriod) {
      case StartPeriod.today:
        return DateTime(now.year, now.month, now.day);
      case StartPeriod.thisMonth:
        return DateTime(now.year, now.month);
      case StartPeriod.thisYear:
        return DateTime(now.year);
      case StartPeriod.none:
      default:
        return null;
    }
  }

  void dispose() {
    _addBtnEnabledCtrl.close();
    _loadingCtrl.close();
    _selectedStartPeriodCtrl.close();
  }

  UserShouldBeSetBeforeReadingAllNotes() {}
}

enum StartPeriod { none, today, thisMonth, thisYear }
