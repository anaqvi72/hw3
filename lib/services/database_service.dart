import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hw3/models/conversation.dart';
import 'package:hw3/models/message.dart';
import 'package:hw3/models/post.dart';
import 'package:hw3/models/user.dart';
import 'package:hw3/screens/messagescreen.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, user> userMap = <String, user>{};

  final StreamController<Map<String, user>> _usersController =
      StreamController<Map<String, user>>();

  final StreamController<List<conversation>> _converationController =
      StreamController<List<conversation>>();

  final StreamController<List<Message>> _messageController =
      StreamController<List<Message>>();

  DatabaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
    _firestore
        .collection('conversations')
        .snapshots()
        .listen(_conversationUpdated);
  }

  void getMessageList(String messageNumber) {
    _firestore.collection('messages').snapshots().listen(_messagesUpdated);
  }

  Stream<Map<String, user>> get users => _usersController.stream;
  Stream<List<conversation>> get convos => _converationController.stream;
  Stream<List<Message>> get message => _messageController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _conversationUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var conversations = _getConversationsFromSnapshot(snapshot);
    _converationController.add(conversations);
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var messages = _getMessagesFromSnapshot(snapshot);
    _messageController.add(messages);
  }

  Map<String, user> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      user User = user.fromMap(element.id, element.data());
      userMap[User.id] = User;
    }

    return userMap;
  }

  List<conversation> _getConversationsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<conversation> conversations = [];
    for (var element in snapshot.docs) {
      conversation convo = conversation.fromMap(element.id, element.data());
      conversations.add(convo);
    }

    return conversations;
  }

  List<Message> _getMessagesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = [];
    for (var element in snapshot.docs) {
      Message txt = Message.fromMap(element.id, element.data());
      messages.add(txt);
    }

    return messages;
  }

  Future<user> getUser(String uid) async {
    var snapshot = await _firestore.collection("users").doc(uid).get();

    return user.fromMap(snapshot.id, snapshot.data()!);
  }

  Future<void> setUser(
      String uid, String username, String firstname, String lastname) async {
    String now = DateTime.now().toString();
    String intialrank = '0';
    await _firestore.collection("users").doc(uid).set({
      'convo': intialrank,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
    });
    return;
  }

  Future<void> addPost(String uid, String message) async {
    await _firestore.collection("posts").add({
      'message': message,
      'type': 0,
      'owner': uid,
      "created": DateTime.now()
    });
    return;
  }

  Future<void> addConversation(List<String> users, String messageNumber) async {
    await _firestore.collection("conversations").add({
      'messageNumber': messageNumber,
      'users': users,
    });
    return;
  }

  Future<void> addMessage(
      List<String> users, String messageNumber, String txt) async {
    await _firestore.collection("messages").add({
      'messageNumber': messageNumber,
      'users': users,
      'txt': txt,
    });
    return;
  }
}
