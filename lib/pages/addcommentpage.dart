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
          padding: const EdgeInsets.all(16.0),
          child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: _addComment,
                    child: Text("Add Comment"),
                  ),
                  MaterialButton(
                    onPressed: __editComment,
                    child: Text("Edit Comment"),
                  ),
                  MaterialButton(
                    onPressed: __deleteComment,
                    child: Text("Delete Comment"),
                  ),
                ],
    )
    ));
  }
}
