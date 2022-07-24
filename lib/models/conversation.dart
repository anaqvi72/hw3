import 'dart:collection';

class conversation {
  conversation({
    required this.conversation_ID,
    required this.messageNumber,
    required this.users,
  });

  factory conversation.fromMap(String id, Map<String, dynamic> data) {
    return conversation(
      conversation_ID: id,
      users: [],
      messageNumber: data['messageNumber'],
    );
  }

  final String conversation_ID;
  final String messageNumber;
  final List<String> users;
}
