import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/reporterPages/newsfeed.dart';
import 'package:flutter_project/pages/reporterPages/reportnews.dart';
import 'package:flutter_project/routes/routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppDrawer extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    void signOut() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context, rootNavigator: true).pop();
    }

    void logoutAlert(context){
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Log out",
        desc: "Are you sure you want to log out?",
        buttons: [
          DialogButton(
            child: Text(
              "Log out",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: signOut,
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]),
          )
        ],
      ).show();
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.my_library_books_sharp ,
              text: 'News Feed',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.newsfeed)),
          _createDrawerItem(
              icon: Icons.podcasts_rounded,
              text: 'Report News',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.reportnews)),
          _createDrawerItem(
              icon: Icons.person_pin,
              text: 'My Profile',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.reportnews)),
          ListTile(
            title: Text(''),
            onTap: () {},
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: () => logoutAlert(context)),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),

          ListTile(
            title: Text('0.0.1v'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('images/banner.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("NEWS REPORTER",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData? icon, String? text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text!),
          )
        ],
      ),
      onTap: onTap,
    );
  }



}


//referred from : https://medium.com/flutter-community/flutter-vi-navigation-drawer-flutter-1-0-3a05e09b0db9