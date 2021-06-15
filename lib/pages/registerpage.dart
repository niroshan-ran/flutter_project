import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/dialoges/loading_dialog.dart';
import 'package:flutter_project/pages/verifypage.dart';
import 'package:flutter_project/providers/user_provider.dart';
import 'package:flutter_project/services/firestore_service.dart';
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
  final firestoreService = FirestoreService();
  String _password = "", _confirmPassword = "";
  final GlobalKey _loaderDialog = new GlobalKey();
  var focusEmailNode = FocusNode();
  var focusPasswordNode = FocusNode();
  var focusNickNameNode = FocusNode();
  var focusConfirmPasswordNode = FocusNode();

  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final nickNameText = TextEditingController();
  final confirmPasswordText = TextEditingController();

  void focusText(textNode, context) {
    FocusScope.of(context).requestFocus(textNode);
  }

  void clearAllText() {
    emailText.clear();
    passwordText.clear();
    nickNameText.clear();
    confirmPasswordText.clear();
    _confirmPassword = "";
    _character = Positions.guest;
  }

  void clearText(textFieldController) {
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

  Future<bool> _createUser(UserProvider user, BuildContext context) async {
    switch (_character) {
      case Positions.guest:
        user.changePosition("guest");
        break;
      case Positions.reporter:
        user.changePosition("reporter");
        break;
      case Positions.moderator:
        user.changePosition("moderator");
        break;
      default:
        user.changePosition("guest");
        break;
    }

    if (_password != "" &&
        _confirmPassword != "" &&
        user.email != "" &&
        user.nickName != "") {
      if (_password == _confirmPassword) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: user.email, password: _confirmPassword);

          return userCredential.user != null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            LoadingDialog.hideDialog(context);
            clearAllText();
            _showToast('Your Password has to be more than 8 Characters.');
          } else if (e.code == 'email-already-in-use') {
            LoadingDialog.hideDialog(context);
            clearAllText();
            focusText(focusEmailNode, context);
            _showToast('An account already exists for that email.');
          } else if (e.code == 'invalid-email') {
            LoadingDialog.hideDialog(context);
            clearAllText();
            focusText(focusEmailNode, context);
            _showToast('Please Type a valid Email.');
          }
        } catch (e) {
          clearAllText();
          LoadingDialog.hideDialog(context);
          _showErrorToast("Unknown Error Occurred", e);
        }
      } else {
        LoadingDialog.hideDialog(context);
        clearText(passwordText);
        clearText(confirmPasswordText);
        focusText(focusConfirmPasswordNode, context);
        _showToast("Confirmed Password is Not Match");
      }
    } else {
      LoadingDialog.hideDialog(context);
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

  late Positions? _character;

  @override
  void initState() {
    clearAllText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      builder: (context, widget) {
        final userProvider = Provider.of<UserProvider>(context);
        final node = FocusScope.of(context);
        final ui.Size logicalSize = MediaQuery.of(context).size;
        final double _height = logicalSize.height;
        return Scaffold(
            appBar: AppBar(title: Text("Register")),
            body: SingleChildScrollView(
                child: new Container(
                    constraints: BoxConstraints(
                        minHeight: 490, maxHeight: _height - 100),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            focusNode: focusEmailNode,
                            controller: emailText,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            onChanged: (value) {
                              userProvider.changeEmail(value);
                            },
                            decoration:
                                InputDecoration(hintText: "Enter Email..."),
                          ),
                          TextField(
                            focusNode: focusNickNameNode,
                            controller: nickNameText,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            onChanged: (value) {
                              userProvider.changeNickName(value);
                            },
                            decoration:
                                InputDecoration(hintText: "Enter Nick Name..."),
                          ),
                          TextField(
                            focusNode: focusPasswordNode,
                            controller: passwordText,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => node.nextFocus(),
                            onChanged: (value) {
                              _password = value;
                            },
                            decoration:
                                InputDecoration(hintText: "Enter Password..."),
                          ),
                          TextField(
                            focusNode: focusConfirmPasswordNode,
                            controller: confirmPasswordText,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => node.unfocus(),
                            onChanged: (value) {
                              _confirmPassword = value;
                            },
                            decoration: InputDecoration(
                                hintText: "Confirm Password..."),
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
                          ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              RadioListTile<Positions>(
                                  title: const Text('Guest'),
                                  value: Positions.guest,
                                  groupValue: _character,
                                  onChanged: (Positions? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  }),
                              RadioListTile<Positions>(
                                  title: const Text('Reporter'),
                                  value: Positions.reporter,
                                  groupValue: _character,
                                  onChanged: (Positions? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  }),
                              RadioListTile<Positions>(
                                  title: const Text('Moderator'),
                                  value: Positions.moderator,
                                  groupValue: _character,
                                  onChanged: (Positions? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  }),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              LoadingDialog.showLoadingDialog(
                                  context, _loaderDialog);
                              node.unfocus();
                              Future.wait([_createUser(userProvider, context)])
                                  .then((value) {
                                for (bool val in value) {
                                  if (val) {
                                    Future.wait([
                                      firestoreService.saveUser(
                                          userProvider.getCurrentUser())
                                    ]).whenComplete(() {
                                      LoadingDialog.hideDialog(context);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyPage()));
                                    });
                                  } else {
                                    continue;
                                  }
                                }
                              });
                            },
                            child: Text("Register"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              node.unfocus();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text("Already a User?"),
                          ),
                        ],
                      ),
                    ))));
      },
    );
  }
}
