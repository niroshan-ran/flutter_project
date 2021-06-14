import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/admin_drawer.dart';
import 'package:flutter_project/pages/homepage.dart';
import 'package:flutter_project/pages/loginpage.dart';
import 'package:flutter_project/pages/moderatorpage.dart';
import 'package:flutter_project/pages/news_management_admin.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  User? users = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          StreamProvider(
            create: (context) =>
                firestoreService.getUsers(users!.email.toString()),
            initialData: [],
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            Routes.user: (context) => ModeratorPage(),
            Routes.news: (context) => NewsManagementAdminPage(),
            // Routes.newsfeed: (context) => NotesPage(),
          },
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                users = snapshot.data;

                if (users == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }

              return Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          ),
        ));
  }
}
