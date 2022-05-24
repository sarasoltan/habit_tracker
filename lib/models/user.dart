import 'package:project2/db/users_table.dart';

class Users {
  late final int? id;
  late String? email;

  Users({
    required this.id,
    required this.email,
  });

  Users.fromDb(Map<String, dynamic> map) {
    id = map[UsersTable.id];
    email = map[UsersTable.email];
  }
  // Users.fromRow(Map<String, Object?> map)
  //     : id = map[UsersTable.id] as int,
  //       email = map[UsersTable.email] as String;

  // Map<String, dynamic> toDb() {
  //   return {
  //     UsersTable.id: id,
  //     UsersTable.email: email,
  //   };
  // }

}
