import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCommentPage extends StatefulWidget {
  const AddCommentPage({Key? key}) : super(key: key);

  @override
  _AddCommentPageState createState() => _AddCommentPageState();
}

Future<void> _addComment() async {

}

Future<void> __editComment() async {

}

Future<void> __deleteComment() async {

}

class _AddCommentPageState extends State<AddCommentPage> {
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
              //focusNode: focusEmailNode,
              //controller: emailText,
              onChanged: (value) {
              // _email = value;
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
                    onPressed: _addComment,
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
