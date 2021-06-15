import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'guestpage.dart';

class GuestDrawer extends StatefulWidget {
  final nickName;
  final email;

  const GuestDrawer({Key? key,@required this.nickName,@required this.email}) : super(key: key);

  @override
  _GuestDrawerState createState() => _GuestDrawerState();
}

class _GuestDrawerState extends State<GuestDrawer> {
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
                  image: DecorationImage(image: AssetImage("assets/images/admin_avatar.png"))
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Guest News"),
            onTap: () => Navigator.pushReplacementNamed(context, Routers.guest),
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

class Routers {
  static const String guest = GuestPage.routeName;
}

