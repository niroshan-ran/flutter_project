import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/pages/verifypage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum Positions { guest, reporter, moderator }

class _RegisterPageState extends State<RegisterPage> {
  String _email = "",
      _password = "",
      _nickName = "",
      _confirmPassword = "",
      _position = "";

  var focusEmailNode = FocusNode();
  var focusPasswordNode = FocusNode();
  var focusNickNameNode = FocusNode();
  var focusConfirmPasswordNode = FocusNode();

  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final nickNameText = TextEditingController();
  final confirmPasswordText = TextEditingController();

  void focusText(textNode) {
    FocusScope.of(context).requestFocus(textNode);
  }

  void clearAllText() {
    emailText.clear();
    passwordText.clear();
    nickNameText.clear();
    confirmPasswordText.clear();
    _email = "";
    _password = "";
    _confirmPassword = "";
    _nickName = "";
  }

  void clearText(textFieldController, variableString) {
    textFieldController.clear();
    _character = Positions.guest; // For Test
    switch (variableString) {
      case 'email':
        _email = "";
        break;
      case 'password':
        _password = "";
        break;
      case 'confirmPassword':
        _confirmPassword = "";
        break;
      case 'nickName':
        _nickName = "";
        break;
      default:
        _email = "";
        _password = "";
        _confirmPassword = "";
        _nickName = "";
        break;
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

  Future<int> _createUserDoc(userId) async {
    for (String s in userId) {
      if (s != "") {
        FirebaseFirestore.instance.collection('users').doc(s).set({
          'email': _email,
          'nickName': _nickName,
          'position': _position
        }).catchError((error) {
          clearAllText();
          _showToast("Unknown Error Occurred. Please Try Again");
        });

        return 0;
      } else {
        continue;
      }
    }
    return -1;
  }

  Future<String> _createUser() async {
    if (_email != "" &&
        _password != "" &&
        _confirmPassword != "" &&
        _nickName != "" &&
        _position != "") {
      if (_password == _confirmPassword) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _confirmPassword);

          return userCredential.user!.uid;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            _showToast('The password provided is too weak.');
            return "";
          } else if (e.code == 'email-already-in-use') {
            _showToast('The account already exists for that email.');
            return "";
          }
        } catch (e) {
          _showErrorToast("Unknown Error Occurred", e);
          return "";
        }
      } else {
        clearText(confirmPasswordText, 'confirmPassword');
        focusText(focusConfirmPasswordNode);
        _showToast("Confirmed Password is Not Match");
        return "";
      }

      return "";
    } else {
      _showToast("Please Fill all the Required Fields");
      return "";
    }
  }

  Positions? _character = Positions.guest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Page")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                focusNode: focusNickNameNode,
                controller: nickNameText,
                onChanged: (value) {
                  _nickName = value;
                },
                decoration: InputDecoration(hintText: "Enter Nick Name..."),
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
              TextField(
                focusNode: focusConfirmPasswordNode,
                controller: confirmPasswordText,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  _confirmPassword = value;
                },
                decoration: InputDecoration(hintText: "Confirm Password..."),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          child: Text(
                        "Select the Position",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      )))),
              Flexible(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Guest'),
                      leading: Radio<Positions>(
                        value: Positions.guest,
                        groupValue: _character,
                        onChanged: (Positions? value) {
                          setState(() {
                            _character = value;
                            _position = 'guest';
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Reporter'),
                      leading: Radio<Positions>(
                        value: Positions.reporter,
                        groupValue: _character,
                        onChanged: (Positions? value) {
                          setState(() {
                            _character = value;
                            _position = 'reporter';
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Moderator'),
                      leading: Radio<Positions>(
                        value: Positions.moderator,
                        groupValue: _character,
                        onChanged: (Positions? value) {
                          setState(() {
                            _character = value;
                            _position = 'moderator';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        Future.wait([
                          Future.wait([_createUser()])
                              .then((value) => _createUserDoc(value))
                        ]).then((value) {
                          for (int i in value) {
                            if (i > -1) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => VerifyPage()));
                              break;
                            }
                          }
                        });
                      },
                      child: Text("Register"),
                    ),
                    MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      child: Text("Already a User?"),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
