import 'dart:collection';

class Message {
  Message({
    required this.message_ID,
    required this.users,
    required this.messageNumber,
    required this.txt,
  });

  factory Message.fromMap(String id, Map<String, dynamic> data) {
    return Message(
      message_ID: id,
      users: [],
      messageNumber: data['messageNumber'],
      txt: data['txt'],
    );
  }

  final String message_ID;
  final String messageNumber;
  final String txt;
  final List<String> users;
}
