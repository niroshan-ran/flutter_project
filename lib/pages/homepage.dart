import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addcommentpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MaterialButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddCommentPage()));
        },
        child: Text("Comment Pages"),
        ),
      MaterialButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        },
      child: Text("Sign Out@"),
        ),
    ],
    )
      //     child: MaterialButton(
      //   onPressed: () async {
      //     await FirebaseAuth.instance.signOut();
      //   },
      //   child: Text("Sign Out@"),
      // ),),
    ));
  }
}
