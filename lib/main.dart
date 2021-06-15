import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admin_drawer.dart';
import 'package:flutter_project/pages/guest_drawer.dart';
import 'package:flutter_project/pages/guestpage.dart';
import 'package:flutter_project/pages/moderatorpage.dart';
import 'package:flutter_project/pages/news_management_admin.dart';
import 'package:flutter_project/pages/userPages/homepage.dart';
import 'package:flutter_project/pages/userPages/loginpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          Routes.user: (context) => ModeratorPage(),
          Routes.news: (context) => NewsManagementAdminPage(),
          Routers.guest: (context) => GuestPage(),
          // Routes.newsfeed: (context) => NotesPage(),
        },
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Color(0xFF2196F3).withOpacity(.6),
          primaryColor: Color(0xFF2196F3),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Color(0xFF2196F3).withOpacity(.5),
            cursorColor: Color(0xFF2196F3).withOpacity(.6),
            selectionHandleColor: Color(0xFF2196F3).withOpacity(1),
          ),
        ),
        home: MyApp());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  User? users;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            String email = "";
            users = snapshot.data;

            if (users != null) {
              email = users!.email!;

              return HomePage(email: email);
            } else {
              return LoginPage();
            }
          }

          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
