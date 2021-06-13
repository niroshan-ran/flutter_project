import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          'comment': _comment
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
            "comment" : _comment
          }).then((value){
        print(value.id);
      });

    } else{
      _showToast("Please Fill all the Required Fields");
    }
  }

  Future<void> __editComment() async {

  }

  Future<void> __deleteComment() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comment Page")),
      body: Padding(
          padding: const EdgeInsets.only(
            left: 0,
            top: 100,
            right: 0,
            bottom: 20,
          ),
          child:Column(
            children: [
            Image.asset(
            'assets/images/feb.jpg',
            width: 400.0,
            height: 300.0,
            fit: BoxFit.cover,
            ),
            TextField(
              focusNode: focusCommentNode,
              controller: commentText,
              onChanged: (value) {
                _comment = value;
            },
            decoration: InputDecoration(
                hintText: "Add Your Comment",
                contentPadding: const EdgeInsets.only(
                  left: 20,
                  top: 70,
                  right: 0,
                  bottom: 20,
                )
            ),
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.only(
                    left: 12,
                    top: 70,
                    right: 12,
                    bottom: 0,
                    ),
                    onPressed: () {
                      Future.wait([
                        Future.wait([_addComment()])
                            .then((value) => _addCommentDoc(value))
                      ]).then((value) {
                        for (int i in value) {
                          if (i > -1) {
                            Navigator.pop(context);
                            _showToast("Added Successfully");
                            break;
                          }
                        }
                      });
                    },
                    child: Text("Add Comment"),
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 70,
                      right: 12,
                      bottom: 0,
                    ),
                    onPressed: __editComment,
                    child: Text("Edit Comment"),
                  ),
                  MaterialButton(
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 70,
                      right: 12,
                      bottom: 0,
                    ),
                    onPressed: __deleteComment,
                    child: Text("Delete Comment"),
                  ),
                ],
            )
          ]
      )
    ));
  }



}
