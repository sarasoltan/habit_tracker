import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project2/extensions/list/filter.dart';
import 'package:project2/models/habit.dart';
import 'package:project2/models/user.dart';
import 'package:project2/services/crud/crud_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:project2/db/users_table.dart';

const dbName = "habits.db";

class UserService {
  DatabaseUser? _user;
  Database? _db;

  static final UserService _shared = UserService._sharedInstance();
  UserService._sharedInstance();
  factory UserService() => _shared;

  late final StreamController<List<Habit>> _habitsStreamController;

  Stream<List<Habit>> get allNotes =>
      _habitsStreamController.stream.filter((habit) {
        final currentUser = _user;
        if (currentUser != null) {
          return habit.userId == currentUser.id;
        } else {
          return false;
        }
      });

  // final _habitsStreamController =
  //     StreamController<List<Databasehabits>>.broadcast();

  // Stream<List<Databasehabits>> get allHabits => _habitsStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      //we found the user
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUser {
      //we didn't find the user
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      UsersTable.tableName,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromDb(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //check if the email is already exists
    final results = await db.query(
      UsersTable.tableName,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(UsersTable.tableName, {
      email: email.toLowerCase(),
    });
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      UsersTable.tableName,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbPath = join(docspath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

// create user  table

      await db.execute(UsersTable.createQuery);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}
