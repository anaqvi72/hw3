import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hw3/models/conversation.dart';
import 'package:hw3/models/message.dart';
import 'package:hw3/screens/chatscreen.dart';
import 'package:hw3/screens/signin_screen.dart';
import 'package:hw3/screens/userselection.dart';
import 'package:hw3/services/database_service.dart';

class messagescreen extends StatefulWidget {
  final String messageNumber;

  messagescreen({
    required this.messageNumber,
  });

  @override
  _messagescreenState createState() => _messagescreenState();
}

class _messagescreenState extends State<messagescreen> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState() {
    super.initState();
    db = new DatabaseService();
    db.getMessageList(widget.messageNumber);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => chatscreen()));
            },
          ),
        ],
        title: const Text('Chat Screen'),
      ),
      body: StreamBuilder<List<Message>>(
        stream: db.message,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error has occured!"),
            );
          } else {
            var txts = snapshot.data ?? [];

            return txts.isNotEmpty
                ? ListView.builder(
                    itemCount: txts.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (txts[index].messageNumber != widget.messageNumber) {
                        return SizedBox();
                      }
                      return Card(
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text(txts[index].txt),
                          ));
                    })
                : const Center(
                    child: Text("No convos have been made yet."),
                  );
          }
        },
      ),
    );
  }
}
