import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/pages/verifypage.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum Positions { guest, reporter, moderator }

class _RegisterPageState extends State<RegisterPage> {
  String _password = "", _confirmPassword = "";

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
    _confirmPassword = "";
  }

  void clearText(textFieldController, variableString) {
    textFieldController.clear();
    _character = Positions.guest;
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

  Future<bool> _createUser(UserProvider user) async {
    print('OutPut Values :: ${user.email}');

    if (_password != "" &&
        _confirmPassword != "" &&
        user.email != "" &&
        user.position != "" &&
        user.nickName != "") {
      if (_password == _confirmPassword) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: user.email, password: _confirmPassword);

          return userCredential.user != null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            _showToast('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            _showToast('The account already exists for that email.');
          }
        } catch (e) {
          _showErrorToast("Unknown Error Occurred", e);
        }
      } else {
        clearText(confirmPasswordText, 'confirmPassword');
        focusText(focusConfirmPasswordNode);
        _showToast("Confirmed Password is Not Match");
      }
    } else {
      _showToast("Please Fill all the Required Fields");
    }

    return false;
  }

  @override
  void dispose() {
    emailText.dispose();
    passwordText.dispose();
    confirmPasswordText.dispose();
    nickNameText.dispose();
    focusEmailNode.dispose();
    focusConfirmPasswordNode.dispose();
    focusNickNameNode.dispose();
    focusPasswordNode.dispose();
    super.dispose();
  }

  Positions? _character = Positions.guest;

  @override
  void initState() {
    //New Record
    clearAllText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
                  userProvider.changeEmail(value);
                },
                decoration: InputDecoration(hintText: "Enter Email..."),
              ),
              TextField(
                focusNode: focusNickNameNode,
                controller: nickNameText,
                onChanged: (value) {
                  userProvider.changeNickName(value);
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
                            userProvider.changePosition('guest');
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
                            userProvider.changePosition('reporter');
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
                            userProvider.changePosition('moderator');
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
                        Future.wait([_createUser(userProvider)]).then((value) {
                          for (bool val in value) {
                            if (val) {
                              userProvider.saveUser();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => VerifyPage()));
                            } else {
                              continue;
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
