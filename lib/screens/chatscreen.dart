import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hw3/models/conversation.dart';
import 'package:hw3/screens/messagescreen.dart';
import 'package:hw3/screens/signin_screen.dart';
import 'package:hw3/screens/userselection.dart';
import 'package:hw3/services/database_service.dart';

class chatscreen extends StatefulWidget {
  const chatscreen({Key? key}) : super(key: key);

  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String convo;
  late String user_name;

  @override
  initState() {
    super.initState();
    db = new DatabaseService();
    var usersMap = db.users.first.then((users) {
      if (users != null) {
        setState(() {
          convo = (users[_auth.currentUser!.uid]!.convo);
          user_name = (users[_auth.currentUser!.uid]!.username);
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.ac_unit_sharp),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => userselection()));
            },
          ),
        ],
        title: const Text('Chat Screen'),
      ),
      body: StreamBuilder<List<conversation>>(
        stream: db.convos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("An error has occured!"),
            );
          } else {
            var convos = snapshot.data ?? [];

            return convos.isNotEmpty
                ? ListView.builder(
                    itemCount: convos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => messagescreen(
                                        messageNumber:
                                            convos[index].messageNumber)));
                          },
                          child: Text(convos[index].messageNumber));
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
