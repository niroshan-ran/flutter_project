import 'package:flutter/material.dart';
import 'package:flutter_project/models/users.dart';
import 'package:flutter_project/pages/reporterpage.dart';
import 'package:flutter_project/services/firestore_service.dart';

import '../guestpage.dart';
import '../moderatorpage.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreService.getUsers(widget.email),
        builder: (context, AsyncSnapshot<ApplicationUser> snapshot) {
          if (snapshot.hasData) {
            ApplicationUser obj = snapshot.data!;
            switch (obj.position) {
              case 'moderator':
                return ModeratorPage(nickName: obj.nickName, email: obj.email);
              case 'reporter':
                return ReporterPage(nickName: obj.nickName);
              case 'guest':
              default:
                return GuestPage(nickName: obj.nickName, email: obj.email);
            }
          }

          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
          ;
        });
  }
}
