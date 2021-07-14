class User {
  // Constructor for User Class
  User( {
    required this.uid,
    required this.email,
    required this.name,
    required this.userName,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> response) {
    return User(
      uid: response["user"]["_id"],
      userName: response["user"]["alias"],
      email: response["user"]["email"],
      name: response["user"]["name"],
      token: response["jwt"]
    );
  }


  // Essentials of a particular User
  final String uid; // unique id of the user
  final String email; // email of the user
  final String name; // Name of the user
  final String userName; // anonymous username
  final String token;
}
