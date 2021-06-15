import 'dart:ui' as ui;

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/pages/userPages/verifypage.dart';
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
  GlobalKey<FormState>? _formKey;
  late String _password;
  TextEditingController? _emailTextController;
  TextEditingController? _passwordTextController;
  TextEditingController? _nickNameTextController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _password = "";
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _nickNameTextController = TextEditingController();
    clearAllText();
    super.initState();
  }

  void clearAllText() {
    _emailTextController!.clear();
    _passwordTextController!.clear();
    _nickNameTextController!.clear();
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

  Future<void> preRegisterFunction(
      UserProvider userProvider,
      BuildContext context,
      FocusScopeNode node,
      FirestoreService firestoreService) async {
    node.unfocus();
    resetError(false);
    if (_formKey!.currentState!.validate()) {
      Future.wait([_createUser(userProvider, context)]).then((value) {
        try {
          for (bool val in value) {
            if (val) {
              Future.wait([
                firestoreService.saveUser(userProvider.getCurrentUser())
              ]).whenComplete(() {
                toggleShowProgress();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => VerifyPage()));
              });
            } else {
              continue;
            }
          }
        } catch (e) {
          clearAllText();
          resetError(true);
          toggleShowProgress();
          _showErrorToast("Unknown Error Occurred", e);
        }
      });
    }
    toggleShowProgress();
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

    if (user.email != "" && _password != "" && user.nickName != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: user.email, password: _password);

        return userCredential.user != null;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          clearAllText();
          toggleShowProgress();
          _showToast('Your Password has to be more than 8 Characters.');
        } else if (e.code == 'email-already-in-use') {
          clearAllText();
          toggleShowProgress();
          _showToast('An account already exists for that email.');
        } else if (e.code == 'invalid-email') {
          clearAllText();
          toggleShowProgress();
          _showToast('Please Type a valid Email.');
        }
      } catch (e) {
        clearAllText();
        toggleShowProgress();
        _showErrorToast("Unknown Error Occurred", e);
      }
    }

    resetError(true);
    return false;
  }

  @override
  void dispose() {
    _emailTextController!.dispose();
    _passwordTextController!.dispose();
    _nickNameTextController!.dispose();
    super.dispose();
  }

  late Positions? _character;
  bool _obscureText = true;
  bool emailTextValid = true;
  bool passwordTextValid = true;
  bool nickNameTextValid = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void resetError(bool value) {
    emailTextValid = value;
    passwordTextValid = value;
    nickNameTextValid = value;
  }

  bool showProgress = false;

  void toggleShowProgress() {
    setState(() {
      showProgress = !showProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      builder: (context, widget) {
        final userProvider = Provider.of<UserProvider>(context);
        final node = FocusScope.of(context);
        final ui.Size logicalSize = MediaQuery.of(context).size;
        final double _height = logicalSize.height;
        return Scaffold(
            appBar: AppBar(title: Text("Register")),
            body: showProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: new Container(
                        constraints: BoxConstraints(
                            minHeight: 490, maxHeight: _height - 100),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty && !emailTextValid) {
                                        return 'This field is a required field';
                                      }
                                      if (!EmailValidator.validate(value) &&
                                          !emailTextValid) {
                                        return 'Please enter a valid e-mail';
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      helperText:
                                          'Please Type a Valid Working Email for Verification Purpose',
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF2196F3),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailTextController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    onChanged: (value) {
                                      userProvider.changeEmail(value);
                                      emailTextValid = true;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty &&
                                          !nickNameTextValid) {
                                        return 'This field is a required field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      helperText:
                                          'Type Your Most Friendly Name',
                                      labelText: 'Nick Name',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF2196F3),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.name,
                                    controller: _nickNameTextController,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    onChanged: (value) {
                                      userProvider.changeNickName(value);
                                      nickNameTextValid = true;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty &&
                                          !passwordTextValid) {
                                        return 'This field is a required field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: _toggle,
                                        icon: _obscureText
                                            ? Icon(Icons.remove_red_eye)
                                            : Icon(
                                                Icons.remove_red_eye_outlined),
                                      ),
                                      helperText:
                                          "Your Password has to be at-least 8 Characters",
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF2196F3),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: _passwordTextController,
                                    obscureText: _obscureText,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.go,
                                    onChanged: (value) {
                                      _password = value;
                                      passwordTextValid = true;
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 16.0, 0, 0),
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
                                    toggleShowProgress();
                                    preRegisterFunction(userProvider, context,
                                        node, firestoreService);
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
                          ),
                        ))));
      },
    );
  }
}
