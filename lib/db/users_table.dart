class UsersTable {
  static const String tableName = "Users";

  static const String id = "id";
  static const String email = "email";
  //static const String userId = "user_id";

  static const String createQuery = """
  CREATE TABLE $tableName (
	$id	integer primary key autoincrement,
	$email	text not null unique,
  )
  """;
}
