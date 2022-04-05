import 'dart:async';

import 'package:project2/services/crud/crud_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class HabitsService {
  Database? _db;

  List<Databasehabits> _habits = [];

  static final HabitsService _shared = HabitsService._sharedInstance();
  HabitsService._sharedInstance();
  factory HabitsService() => _shared;

  final _habitsStreamController =
      StreamController<List<Databasehabits>>.broadcast();

  Stream<List<Databasehabits>> get allHabits => _habitsStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      //we found the user
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      //we didn't find the user
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

//getting all habits and add them to habits controller
  Future<void> _cachehabits() async {
    final allhabits = await getAllhabits();
    _habits = allhabits.toList();
    _habitsStreamController.add(_habits);
  }

  Future<Databasehabits> updatehabit({
    required Databasehabits habit,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure habit exists
    await gethabit(id: habit.id);

    //update DB
    final updateCount = await db.update(habitTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updateCount == 0) {
      throw CouldNotUpdatehabit();
    } else {
      final updatedhabit = await gethabit(id: habit.id);
      _habits.removeWhere((habit) => habit.id == updatedhabit.id);
      _habitsStreamController.add(_habits);
      return updatedhabit;
    }
  }

  Future<Iterable<Databasehabits>> getAllhabits() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final habits = await db.query(
      habitTable,
    );
    return habits.map((habitRow) => Databasehabits.fromRow(habitRow));
  }

  Future<Databasehabits> gethabit({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final habits = await db.query(
      habitTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (habits.isEmpty) {
      throw CouldNotDeletehabit();
    } else {
      final habit = Databasehabits.fromRow(habits.first);
      _habits.removeWhere((habit) => habit.id == id);
      _habits.add(habit);
      _habitsStreamController.add(_habits);
      return habit;
    }
  }

  Future<int> deleteAllhabits() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(habitTable);
    _habits = [];
    _habitsStreamController.add(_habits);
    return numberOfDeletions;
  }

  Future<void> deletehabit({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      habitTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeletehabit();
    } else {
      _habits.removeWhere((habit) => habit.id == id);
      _habitsStreamController.add(_habits);
    }
  }

  Future<Databasehabits> createhabit({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //making sure owner exists in the db with the corret id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    //create the habit
    final habitId = await db.insert(
      habitTable,
      {userIdColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1},
    );
    final habit = Databasehabits(
      id: habitId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _habits.add(habit);
    _habitsStreamController.add(_habits);

    return habit;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //check if the email is already exists
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
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

// create user and habit table

      await db.execute(createUserTable);
      await _cachehabits();

      await db.execute(createhabitTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID: $id, Email: $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Databasehabits {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  Databasehabits({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  Databasehabits.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'habit, ID= $id, userID = $userId, isSyncedWithCloud = $isSyncedWithCloud, text= $text';
  @override
  bool operator ==(covariant Databasehabits other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "habits.db";
const habitTable = "habit";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
  );''';
const createhabitTable = '''CREATE TABLE IF NOT EXISTS"habit"(
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';
