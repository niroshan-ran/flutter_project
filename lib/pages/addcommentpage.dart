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
  String _name = "";
  String _comment = "";


  var focusCommentNode = FocusNode();
  var focusNameNode = FocusNode();

  final commentText = TextEditingController();
  final nameText = TextEditingController();

  void validateAndSave(){
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
    }else if(variableString == "comment"){
      _name = "";
    }else{
      _comment = "";
      _name = "";
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
          'name':_name,
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
    if (_comment != "" && _name != "") {
      FirebaseFirestore.instance.collection("comments").add(
          {
            "name" : _name,
            "comment" : _comment,
          }).then((value){
        print(value.id);
        _showToast("Added Successfully");
      });

    } else{
      _showToast("Please Fill all the Required Fields");
    }
  }

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

  List<Widget> createInputs(){
    return [
      SizedBox(height: 20.0,),

      new TextFormField(
        focusNode: focusNameNode,
        controller: nameText,
        onChanged: (value) {
          _name = value;
        },
        decoration: new InputDecoration(
            labelText: 'Your Name',
          filled: true,
          prefixIcon: Icon(
            Icons.account_box,
            size: 20.0,
          ),
          suffixIcon: IconButton(
            onPressed: () => nameText.clear(),
            icon: Icon(Icons.clear),
          ),
        ),
      ),

      SizedBox(height: 20.0,),

      new TextFormField(
        focusNode: focusCommentNode,
        controller: commentText,
        onChanged: (value) {
          _comment = value;
        },
        decoration: new InputDecoration(
            labelText: 'Comment',
          filled: true,
          prefixIcon: Icon(
            Icons.comment,
            size: 20.0,
          ),
          suffixIcon: IconButton(
            onPressed: () => commentText.clear(),
            icon: Icon(Icons.clear),
          ),
        ),

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
      // ignore: deprecated_member_use
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
                    return guestCommentUI(list[index]["name"],list[index]["comment"]);
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
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget guestCommentUI(String name,String comment){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding:  new EdgeInsets.all(14.0),

        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            new Text(
              name,
              style: new TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),

            new Text(
              comment,
              style: new TextStyle(
                fontSize: 10.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
