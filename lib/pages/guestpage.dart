import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/pages/guest_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'addcommentpage.dart';

class GuestPage extends StatefulWidget {
  final nickName;
  final email;

  static const String routeName = '/guestManagement';

  const GuestPage({Key? key, @required this.nickName,@required this.email}) : super(key: key);

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
        drawer: GuestDrawer(nickName: widget.nickName,email: widget.email),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('All Guest News'),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('News').where("isPublish", isEqualTo: true).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
                    if(querySnapshot.hasError)
                      _showToast("Error has occur!");

                    if(querySnapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else{

                      final list = (querySnapshot.data! as QuerySnapshot).docs;

                      return ListView.builder(
                        itemBuilder: (context, index){
                          return guestNewsUI(list[index]["title"], list[index]["description"],list[index]["image"],list[index]["date"]);
                          // return ListTile(
                          //   title : Text(list[index]["title"]),
                          //   subtitle : Text(list[index]["image"])
                          // );
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

  Widget guestNewsUI(String title, String description, String image, String date){
    
    return new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: new Container(
        padding:  new EdgeInsets.all(14.0),

        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child:new Text(
                  title,
                  style: new TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                ),
              ],
            ),

            SizedBox(height: 10.0,),

            new Image.network(image, fit:BoxFit.cover),

            SizedBox(height: 10.0,),

            new Text(
              description,
              style: new TextStyle(
                fontSize: 10.0,
                  fontStyle: FontStyle.italic
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40.0,),

            new IconButton(
              icon: Icon(Icons.comment,color: Colors.cyan,),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddCommentPage()));
              },
            ),
            new Text(
              date,
              style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
