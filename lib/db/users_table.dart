import 'package:project2/models/user.dart';

class UsersTable {
  static const String tableName = 'Users';

  static const String id = 'id';
  static const String email = 'email';
  //static const String userId = "user_id";

  static const String createQuery = '''
  CREATE TABLE IF NOT EXISTS $tableName (
	$id	integer primary key autoincrement,
	$email text not null unique);''';

  @override
  String toString() => 'Person, ID: $id, email: $email';

  @override
  bool operator ==(covariant Users other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
