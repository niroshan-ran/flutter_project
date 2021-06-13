import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/guestpage.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddCommentPage extends StatefulWidget {
  const AddCommentPage({Key? key}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}


class _AddCommentPageState extends State<AddCommentPage> {
  String _comment = "";


  var focusCommentNode = FocusNode();

  final commentText = TextEditingController();

  void validateAndSave(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GuestPage()));
    Future.wait([
      Future.wait([_addComment()])
          .then((value) => _addCommentDoc(value))
    ]);
  }

  void focusText(textNode) {
    FocusScope.of(context).requestFocus(textNode);
  }


  void clearText(textFieldController, variableString) {
    textFieldController.clear();
    if(variableString == "comment"){
      _comment = "";
    }
  }


  void _showErrorToast(message, error) {
    Fluttertoast.showToast(
        msg: "$message | $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1);
  }

  void _showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1);
  }

  Future<int> _addCommentDoc(commentId) async {
    for (String cID in commentId) {
      if (cID != "") {
        FirebaseFirestore.instance.collection('comments').doc(cID).set({
          'comment': _comment,
        }).catchError((error) {
          focusText(focusCommentNode);
          _showToast("Unknown Error Occurred. Please Try Again");
        });
        return 0;
      } else {
        continue;
      }
    }
    return -1;
  }

  Future<void> _addComment() async{
    if (_comment != "") {
      FirebaseFirestore.instance.collection("comments").add(
          {
            "comment" : _comment,
          }).then((value){
        print(value.id);
        _showToast("Added Successfully");
      });

    } else{
      _showToast("Please Fill all the Required Fields");
    }
  }

  // Future<void> __editComment() async {
  //
  // }
  //
  // Future<void> __deleteComment() async {
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comment Page")),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createImage() + createInputs() + createButtons() + viewComment(),
            )
        ),
    ));
  }

  // getItem(var subject) {
  //   var row = Container(
  //     margin: EdgeInsets.all(8.0),
  //     child: Row(
  //       children: <Widget>[
  //         Container(
  //           width: 100.0,
  //           height: 150.0,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //             color: Colors.redAccent,
  //           ),
  //           child: Image.asset(
  //             subject['images']['large'],
  //             height: 150.0,
  //             width: 100.0,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   return Card(
  //     color: Colors.blueGrey,
  //     child: row,
  //   );
  // }

  List<Widget> createInputs(){
    return [
      SizedBox(height: 20.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText: 'Add your Comment'),
      )
    ];
  }

  List<Widget> createImage(){
    return [
      SizedBox(height: 20.0,),

      new Image.asset(
          'assets/images/feb.jpg',
          fit: BoxFit.cover,
      )
    ];
  }

  List<Widget> createButtons(){
    return [
      new RaisedButton(
        child: new Text("Post", style: new TextStyle(fontSize: 20.0),),
        textColor: Colors.white,
        color: Colors.cyan,

        onPressed: validateAndSave,
      ),
    ];
  }

  List<Widget> viewComment(){
    return[
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
                    return guestCommentUI(list[index]["comment"]);
                  },
                  itemCount: list.length,
                );
              }
            },
          )
      )
    ];
  }

  Widget guestImageUI(String image){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),


      child: new Container(
        padding:  new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            SizedBox(height: 10.0,),

            new Text(
              image,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget guestCommentUI(String comment){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),


      child: new Container(
        padding:  new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            SizedBox(height: 10.0,),

            new Text(
              comment,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
