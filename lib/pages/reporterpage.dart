import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/reporterPages/newsfeed.dart';
import 'package:flutter_project/pages/reporterPages/reporterProfile.dart';
import 'package:flutter_project/pages/reporterPages/reportnews.dart';
import 'package:flutter_project/routes/routes.dart';
import 'package:flutter_project/widget/drawer.dart';

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
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          primarySwatch: Colors.amber
      ),
      home: NewsFeed(),
      routes:  {
        Routes.newsfeed: (context) => NewsFeed(),
        Routes.reportnews: (context) => ReportNews(),
        Routes.myprofile: (context) => MyProfilePage(),
      },
    );

  }
}
