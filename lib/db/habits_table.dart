import 'package:project2/db/user_services.dart';
import 'package:project2/db/users_table.dart';

class HabitsTable {
  static const String tableName = 'Habits';

  static const String id = 'id';
  //static const String userId = 'userId';
  static const String text = 'text';
  static const String emoji = 'emoji';
  static const String period = 'period';
  static const String startPeriod = 'startPeriod';

  static const String createQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,

      $text TEXT NOT NULL,
      $emoji TEXT NOT NULL,
      $period TEXT NOT NULL,
      $startPeriod INTEGER
      )''';
}
//line 17    $userId INTEGER NOT NULL, line 22 FOREIGN KEY($userId) REFERENCES ${UsersTable.tableName}(id));
