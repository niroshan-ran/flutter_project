import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'moderatorpage.dart';
import 'news_management_admin.dart';

class AdminDrawer extends StatefulWidget {
  final nickName;
  final email;
  const AdminDrawer({Key? key,@required this.nickName,@required this.email}) : super(key: key);

  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${widget.nickName}'),
            accountEmail: Text('${widget.email}'),
            currentAccountPicture: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(image: AssetImage("assets/admin_avatar.png"))
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Users"),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.user),
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text("Articles"),
            onTap: () =>  Navigator.pushReplacementNamed(context, Routes.news),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log Out"),
            onTap: signOut,
          )
        ],
      ),
    );
  }
}

class Routes {
  static const String user = ModeratorPage.routeName;
  static const String news = NewsManagementAdminPage.routeName;
}

