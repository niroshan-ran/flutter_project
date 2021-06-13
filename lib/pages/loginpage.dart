import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/registerpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "", _password = "";

  final emailText = TextEditingController();
  final passwordText = TextEditingController();

  var focusEmailNode = FocusNode();
  var focusPasswordNode = FocusNode();

  void focusEmail() {
    FocusScope.of(context).requestFocus(focusEmailNode);
  }

  void focusPassword() {
    FocusScope.of(context).requestFocus(focusPasswordNode);
  }

  void clearEmail() {
    emailText.clear();
    _email = "";
  }

  void clearPassword() {
    passwordText.clear();
    _password = "";
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

  Future<void> _login() async {
    if (_email != "" && _password != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          clearEmail();
          clearPassword();
          focusEmail();
          _showToast("The Email is not Exist");
        } else if (e.code == 'wrong-password') {
          clearPassword();
          focusPassword();
          _showToast("Incorrect Password");
        } else if (e.code == 'invalid-email') {
          clearEmail();
          clearPassword();
          focusEmail();
          _showToast("Invalid Email");
        } else {
          _showErrorToast("Unknown Error Occurred", e);
        }
      } catch (e) {
        _showErrorToast("Unknown Error Occurred", e);
      }
    } else {
      _showToast("Please Fill all the Required Fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                focusNode: focusEmailNode,
                controller: emailText,
                onChanged: (value) {
                  _email = value;
                },
                decoration: InputDecoration(hintText: "Enter Email..."),
              ),
              TextField(
                focusNode: focusPasswordNode,
                controller: passwordText,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  _password = value;
                },
                decoration: InputDecoration(hintText: "Enter Password..."),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: _login,
                      child: Text("Login"),
                    ),
                    MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      child: Text("New User?"),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
