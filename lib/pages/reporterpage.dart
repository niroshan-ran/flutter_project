import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReporterPage extends StatefulWidget {
  final nickName;
  const ReporterPage({Key? key, @required this.nickName}) : super(key: key);

  @override
  _ReporterPageState createState() => _ReporterPageState();
}

class _ReporterPageState extends State<ReporterPage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Reporter Page")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome Reporter ${widget.nickName}'),
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
