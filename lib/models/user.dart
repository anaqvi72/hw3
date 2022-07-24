class user {
  user({
    required this.id,
    required this.convo,
    required this.username,
    required this.firstname,
    required this.lastname,
  });

  factory user.fromMap(String id, Map<String, dynamic> data) {
    return user(
      id: id,
      convo: data['convo'],
      username: data['username'],
      firstname: data['firstname'],
      lastname: data['lastname'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'convo': convo,
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
      };

  final String id;
  final String convo;
  final String username;
  final String firstname;
  final String lastname;
}
