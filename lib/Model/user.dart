class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;

  User({this.id, this.username, this.email, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
    );
  }
}
