import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/users.dart';
import 'package:flutter_project/pages/loginpage.dart';
import 'package:flutter_project/pages/reporterpage.dart';
import 'package:provider/provider.dart';

import 'guestpage.dart';
import 'loginpage.dart';
import 'moderatorpage.dart';
import 'news_management_admin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userProviders = Provider.of<List<ApplicationUser>>(context);

    for (ApplicationUser obj in userProviders) {
      switch (obj.position) {
        case 'moderator':
          return ModeratorPage(nickName: obj.nickName);
        case 'reporter':
          return ReporterPage(nickName: obj.nickName);
        default:
          return GuestPage(nickName: obj.nickName);
      }
    }

    return LoginPage();
  }
}
