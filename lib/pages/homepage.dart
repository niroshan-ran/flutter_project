import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/reporterpage.dart';

import 'guestpage.dart';
import 'loginpage.dart';
import 'moderatorpage.dart';

class HomePage extends StatefulWidget {
  final userEmail;

  const HomePage({Key? key, this.userEmail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var futureRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.userEmail)
        .get();

    return FutureBuilder(
      future: futureRef,
      builder: (context, AsyncSnapshot snapshot) {
        QuerySnapshot<Map<String, dynamic>> userResult = snapshot.data;
        List<QueryDocumentSnapshot<Map<String, dynamic>>> userResultDocs =
            userResult.docs;

        for (var obj in userResultDocs) {
          switch (obj.get('position')) {
            case 'moderator':
              return ModeratorPage(nickName: obj.get('nickName'));
            case 'reporter':
              return ReporterPage(nickName: obj.get('nickName'));
            case 'guest':
              return GuestPage(nickName: obj.get('nickName'));
            default:
              break;
          }
        }

        return LoginPage();
      },
    );
  }
}
