import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/userPages/loginpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homepage.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late GlobalKey? _loaderDialog;

  void sendEmail() {
    toggleShowProgress();
    user = auth.currentUser!;
    user.sendEmailVerification().whenComplete(() {
      _showToast("Verification Email Sent");
    });
    toggleShowProgress();
  }

  @override
  void initState() {
    _loaderDialog = new GlobalKey();

    sendEmail();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  Future<void> signOut(BuildContext context) async {
    timer.cancel();
    toggleShowProgress();
    await FirebaseAuth.instance.signOut();
    toggleShowProgress();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void checkEmail(BuildContext context) {
    toggleShowProgress();
    if (user.emailVerified) {
      toggleShowProgress();
      timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(email: user.email!)));
    } else {
      toggleShowProgress();
      _showToast("Email is not yet Verified");
    }
  }

  bool showProgress = false;

  void toggleShowProgress() {
    setState(() {
      showProgress = !showProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Verify Email")),
        body: showProgress
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Verification Email Sent'),
                        subtitle: Text('Please verify your Email Address'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('Resend Email'),
                            onPressed: sendEmail,
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('Retry Login'),
                            onPressed: () {
                              toggleShowProgress();
                              checkEmail(context);
                              toggleShowProgress();
                              _showToast("Verification Email Sent");
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('Exit'),
                            onPressed: () => signOut(context),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }

  void _showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1);
  }

  Future<void> _checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
  }
}
