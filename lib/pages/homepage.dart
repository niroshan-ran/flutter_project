import 'package:flutter/material.dart';
import 'package:flutter_project/models/users.dart';
import 'package:flutter_project/pages/loginpage.dart';
import 'package:flutter_project/pages/reporterpage.dart';
import 'package:flutter_project/services/firestore_service.dart';

import 'guestpage.dart';
import 'loginpage.dart';
import 'moderatorpage.dart';

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
        builder: (context, AsyncSnapshot<List<ApplicationUser>> snapshot) {
          if (snapshot.hasData) {
            for (ApplicationUser obj in snapshot.requireData) {
              switch (obj.position) {
                case 'moderator':
                  return ModeratorPage(nickName: obj.nickName);
                case 'reporter':
                  return ReporterPage(nickName: obj.nickName);
                default:
                  return GuestPage(nickName: obj.nickName);
              }
            }
          }

          return LoginPage();
        });
  }
}
