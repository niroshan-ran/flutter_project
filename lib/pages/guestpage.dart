import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/guestnews.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'addcommentpage.dart';

class GuestPage extends StatefulWidget {
  final nickName;
  const GuestPage({Key? key, @required this.nickName}) : super(key: key);

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  void _showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Guest Page")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Welcome Guest ${widget.nickName}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: signOut,
                  child: Text('Sign Out'),
                ),
                MaterialButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddCommentPage()));
                  },
                  child: Text("Comment Pages"),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('comments').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
                    if(querySnapshot.hasError)
                      _showToast("Error has occur!");

                    if(querySnapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else{

                      final list = (querySnapshot.data! as QuerySnapshot).docs;

                      return ListView.builder(
                        itemBuilder: (context, index){
                          return ListTile(
                              title : Text(list[index]["comment"])
                          );
                        },
                        itemCount: list.length,
                      );
                    }
                  },
                )
            )
          ]),
        ));
  }

  Widget guestNewsUI(String title, String description, String image, String nickName){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),


      child: new Container(
        padding:  new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),

                new Text(
                  nickName,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            SizedBox(height: 10.0,),

            new Image.network(image, fit:BoxFit.cover),

            SizedBox(height: 10.0,),

            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
