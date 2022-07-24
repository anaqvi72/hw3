import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hw3/models/user.dart';
import 'package:hw3/screens/chatscreen.dart';
import 'package:hw3/screens/sendmessage.dart';
import 'package:hw3/screens/signin_screen.dart';
import 'package:hw3/services/database_service.dart';

class userselection extends StatefulWidget {
  const userselection({Key? key}) : super(key: key);

  @override
  _userselectionState createState() => _userselectionState();
}

class _userselectionState extends State<userselection> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String convo;
  late String user_name;
  List<user> choices = [];
  List<String> usersrecipients = [];
  @override
  initState() {
    super.initState();
    db = new DatabaseService();
    var usersMap = db.users.first.then((users) {
      if (users != null) {
        setState(() {
          users.forEach((k, v) => choices.add(v));
          print("--------->" + usersrecipients.length.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: choices.length,
                itemBuilder: (BuildContext context, int index) {
                  SizedBox(
                    height: 20,
                  );
                  const Text("Please Click A User To Start ");
                  SizedBox(
                    height: 20,
                  );
                  if (choices.elementAt(index).id == _auth.currentUser!.uid) {
                    return SizedBox();
                  }
                  return Column(children: [
                    OutlinedButton(
                        onPressed: () {
                          usersrecipients.add(_auth.currentUser!.uid);
                          usersrecipients
                              .add(choices.elementAt(index).id.toString());
                        },
                        child:
                            Text(choices.elementAt(index).username.toString()))
                  ]);
                }),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          sendmessage(recipients: usersrecipients)));
            },
            child: Text("Send Message"),
          ),
        ],
      ),
    );
  }
}
