import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hw3/models/message.dart';
import 'package:hw3/models/user.dart';
import 'package:hw3/reusable/reusable.dart';
import 'package:hw3/screens/chatscreen.dart';
import 'package:hw3/screens/signin_screen.dart';
import 'package:hw3/services/database_service.dart';

class sendmessage extends StatefulWidget {
  final List<String> recipients;

  sendmessage({
    required this.recipients,
  });
  @override
  _sendmessageState createState() => _sendmessageState();
}

class _sendmessageState extends State<sendmessage> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _messageTextController = TextEditingController();
  @override
  initState() {
    super.initState();
    db = new DatabaseService();
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    String randomNumber = random.nextInt(100).toString();
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        reusableTextField("Enter Your Messages", Icons.person_outline, false,
            _messageTextController),
        OutlinedButton(
            onPressed: () {
              startConvo(randomNumber);
              startMessage(_messageTextController.text, randomNumber);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => chatscreen()));
            },
            child: Text("Send Message")),
      ],
    ));
  }

  Future<void> startConvo(var randomNumber) async {
    await db.addConversation(widget.recipients, randomNumber);
  }

  Future<void> startMessage(var message, var randomNumber) async {
    await db.addMessage(widget.recipients, randomNumber, message);
  }
}
