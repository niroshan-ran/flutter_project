import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widget/drawer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewsFeed extends StatefulWidget {
  static const String routeName = '/newsFeed';
  final nickName;
  const NewsFeed({Key? key, @required this.nickName}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text("News Feed"),
            backgroundColor: Colors.amber),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome Reporter ${widget.nickName}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  // onPressed: () => logoutAlert(context),
                  onPressed: () {  },
                  child: Text('Sign Out'),
                )
              ],
            )
          ]),
        ));
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

}
