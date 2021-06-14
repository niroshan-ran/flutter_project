import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/reporterPages/newsfeed.dart';
import 'package:flutter_project/pages/reporterPages/reportnews.dart';
import 'package:flutter_project/routes/routes.dart';
import 'package:flutter_project/widget/drawer.dart';

class MyProfilePage extends StatefulWidget {
  static const String routeName = '/myProfile';
  final nickName;
  const MyProfilePage({Key? key, @required this.nickName}) : super(key: key);



  // @override
  // State<StatefulWidget> createState() {
  //   return _MyProfilePageState();
  // }
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            title: Text("My Profile"),
            backgroundColor: Colors.amber),
        backgroundColor: Colors.white70,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/banner.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Welcome back Sachi',
                style: TextStyle(
                  fontFamily: 'Sacramento',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "News Reporter",
                style: TextStyle(fontSize: 15, fontFamily: 'EBGaramond'),
              ),
              SizedBox(
                height: 10,
                width: 150,
                child: Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.amber,
                child: ListTile(
                  leading: Icon(Icons.accessibility_new_rounded),
                  title: Text('Reporter'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.amber,
                child: ListTile(
                  leading: Icon(Icons.mail),
                  title: Text('s.antany@gmail.com'),
                ),
              )
            ],
          ),
        ));



      //
      // Scaffold(
      //   drawer: AppDrawer(),
      //   appBar: AppBar(
      //       title: Text("My Profile"),
      //       backgroundColor: Colors.amber),
      //   body: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Text('Welcome Reporter ${widget.nickName}'),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           MaterialButton(
      //             onPressed: signOut,
      //             child: Text('Sign Out'),
      //           )
      //         ],
      //       )
      //     ]),
      //   ));
  }



}
