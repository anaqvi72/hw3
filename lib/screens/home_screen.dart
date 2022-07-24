import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hw3/screens/chatscreen.dart';
import 'package:hw3/screens/signin_screen.dart';
import 'package:hw3/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String convo;
  late String a;

  @override
  initState() {
    super.initState();
    db = new DatabaseService();
    var usersMap = db.users.first.then((users) {
      if (users != null) {
        setState(() {
          convo = (users[_auth.currentUser!.uid]!.convo);
          a = (users[_auth.currentUser!.uid]!.username);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Profile",
          style: TextStyle(fontSize: 50, color: Colors.blueAccent),
        ),
        Text(" User Name " + a),
        Text(" Conversation Rank " + convo),
        OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => chatscreen())));
            },
            child: const Text("Chat"))
      ],
    ));
  }
}
