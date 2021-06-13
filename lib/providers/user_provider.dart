import 'package:flutter/material.dart';
import 'package:flutter_project/models/users.dart';
import 'package:flutter_project/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  late String _email;
  late String _nickName;
  late String _position;
  late String _userId;

  //Getters
  String get email => _email;
  String get nickName => _nickName;
  String get position => _position;

  //Setters
  changeEmail(String value) {
    _email = value;
    notifyListeners();
  }

  changeNickName(String value) {
    _nickName = value;
    notifyListeners();
  }

  changePosition(String value) {
    _position = value;
    notifyListeners();
  }

  loadValues(User user) {
    _userId = user.userId;
    _email = user.email;
    _nickName = user.nickName;
    _position = user.position;
  }

  saveUser() {
    // ignore: unnecessary_null_comparison
    if (_userId == null) {
      var newUser = User(
          userId: email, email: email, nickName: nickName, position: position);
      firestoreService.saveUser(newUser);
    } else {
      //Update
      var updatedUser = User(
          userId: _userId,
          email: _email,
          nickName: nickName,
          position: position);
      firestoreService.updateUser(updatedUser);
    }
  }

  removeUser(String userId) {
    firestoreService.removeUser(userId);
  }
}
