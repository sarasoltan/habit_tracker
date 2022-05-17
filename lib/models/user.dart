import 'package:project2/db/users_table.dart';

class DatabaseUser {
  late final int id;
  late String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromDb(Map<String, dynamic> map) {
    id = map[UsersTable.id];
    email = map[UsersTable.email];
  }

  Map<String, dynamic> toDb() {
    return {
      UsersTable.id: id,
      UsersTable.email: email,
    };
  }

  @override
  String toString() => 'Person, ID: $id, Email: $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
