import 'package:project2/db/user_services.dart';
import 'package:project2/db/users_table.dart';

class HabitsTable {
  static const String tableName = 'Habits';

  static const String id = 'id';
  static const String userId = 'userId';
  static const String text = 'text';
  static const String emoji = 'emoji';
  static const String period = 'period';
  static const String startPeriod = 'startPeriod';

  static const String createQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id integer primary key autoincrement,
      $userId integer not null,
      $text text not null,
      $emoji text not null,
      $period text not null,
      $startPeriod integer,
      FOREIGN Key($userId) REFERENCES ${UsersTable.tableName}(${UsersTable.id}));''';
}
