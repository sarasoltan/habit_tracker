import 'package:project2/models/user.dart';

class UsersTable {
  static const String tableName = 'user';
  static const String idColumn = 'id';
  static const String emailColumn = 'email';

  static const String createQuery = '''
  CREATE TABLE IF NOT EXISTS $tableName (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	email TEXT NOT NULL UNIQUE );''';

  // @override
  // String toString() => 'Person, ID: $id, email: $email';

  // @override
  // bool operator ==(covariant Users other) => id == other.id;

  // @override
  // int get hashCode => id.hashCode;
}
