import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModeratorPage extends StatefulWidget {
  final nickName;

  const ModeratorPage({Key? key, @required this.nickName}) : super(key: key);

  @override
  _ModeratorPageState createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Moderator Page")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome Moderator ${widget.nickName}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: signOut,
                  child: Text('Sign Out'),
                )
              ],
            )
          ]),
        ));
  }
}
