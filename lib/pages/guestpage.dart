import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GuestPage extends StatefulWidget {
  final nickName;
  const GuestPage({Key? key, @required this.nickName}) : super(key: key);

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Guest Page")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome Guest ${widget.nickName}'),
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
