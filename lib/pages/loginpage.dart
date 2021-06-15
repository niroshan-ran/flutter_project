import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/dialoges/loading_dialog.dart';
import 'package:flutter_project/pages/registerpage.dart';
import 'package:flutter_project/pages/verifypage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState>? _formKey;
  GlobalKey? _loaderDialog;
  late String _email, _password;

  TextEditingController? _emailTextController;
  TextEditingController? _passwordTextController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _loaderDialog = new GlobalKey();
    _email = "";
    _password = "";
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    clearAllText();
    super.initState();
  }

  void clearAllText() {
    clearEmail();
    clearPassword();
  }

  void clearEmail() {
    _emailTextController!.clear();

    setState(() {
      _email = "";
    });
  }

  void clearPassword() {
    _passwordTextController!.clear();
    setState(() {
      _password = "";
    });
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

  Future<int> _login() async {
    if (_email != "" && _password != "") {
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        if (credential.user!.emailVerified) {
          return 1;
        } else {
          return -1;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          clearAllText();
          _showToast("The Account is not Existing");
        } else if (e.code == 'wrong-password') {
          clearPassword();
          _showToast("Incorrect Password");
        } else if (e.code == 'invalid-email') {
          clearAllText();
          _showToast("Invalid Email");
        } else {
          clearAllText();
          _showErrorToast("Unknown Error Occurred", e);
        }
      } catch (e) {
        clearAllText();
        _showErrorToast("Unknown Error Occurred", e);
      }
    }

    resetError(true);
    return 0;
  }

  bool _obscureText = true;

  @override
  void dispose() {
    _emailTextController!.dispose();
    _passwordTextController!.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool emailTextValid = true;
  bool passwordTextValid = true;

  void resetError(bool value) {
    emailTextValid = value;
    passwordTextValid = value;
  }

  void preLoginFunction(BuildContext context, FocusScopeNode node) {
    node.unfocus();
    resetError(false);
    if (_formKey!.currentState!.validate()) {
      LoadingDialog.showLoadingDialog(context, _loaderDialog!);
      Future.wait([_login()]).then((value) {
        for (int i in value) {
          LoadingDialog.hideDialog(context);
          if (i == -1) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VerifyPage()));
          } else if (i == 1) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(
                      email: _email,
                    )));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty && !emailTextValid) {
                        return 'This field is a required field';
                      }
                      if (!EmailValidator.validate(value) && !emailTextValid) {
                        return 'Please enter a valid e-mail';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
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
                      _email = value;
                      emailTextValid = true;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty && !passwordTextValid) {
                        return 'This field is a required field';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: _toggle,
                        icon: _obscureText
                            ? Icon(Icons.remove_red_eye)
                            : Icon(Icons.remove_red_eye_outlined),
                      ),
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
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => preLoginFunction(context, node),
                    onChanged: (value) {
                      _password = value;
                      passwordTextValid = true;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () => preLoginFunction(context, node),
                  child: Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                  },
                  child: Text("New User?"),
                ),
              ],
            )),
      ),
    );
  }
}
