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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuestPage()));
                      Future.wait([
                        Future.wait([_addComment()])
                            .then((value) => _addCommentDoc(value))
                      ]);
                    },
                    child: Text("Post"),
                  ),
                  // MaterialButton(
                  //   padding: const EdgeInsets.only(
                  //     left: 12,
                  //     top: 70,
                  //     right: 12,
                  //     bottom: 0,
                  //   ),
                  //   onPressed: __editComment,
                  //   child: Text("Edit Comment"),
                  // ),
                  // MaterialButton(
                  //   padding: const EdgeInsets.only(
                  //     left: 12,
                  //     top: 70,
                  //     right: 12,
                  //     bottom: 0,
                  //   ),
                  //   onPressed: __deleteComment,
                  //   child: Text("Delete Comment"),
                  // ),
                ],
            ),
          ]
      )
    ));
  }



}
