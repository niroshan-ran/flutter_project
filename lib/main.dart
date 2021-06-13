import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admin_drawer.dart';
import 'package:flutter_project/pages/homepage.dart';
import 'package:flutter_project/pages/loginpage.dart';
import 'package:flutter_project/pages/moderatorpage.dart';
import 'package:flutter_project/pages/news_management_admin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
      routes:  {
        Routes.user: (context) => ModeratorPage(),
        Routes.news: (context) => NewsManagementAdminPage(),
        // Routes.newsfeed: (context) => NotesPage(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? users = snapshot.data;

                if (users == null) {
                  return LoginPage();
                } else {
                  return HomePage(userEmail: users.email);
                }
              }

              return Scaffold(
                  body: Center(child: Text("Checking Authentication...")));
            },
          );
        }

        return Scaffold(body: Center(child: Text("Loading...")));
      },
    );
  }
}
