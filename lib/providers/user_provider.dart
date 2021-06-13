import 'package:flutter/material.dart';
import 'package:flutter_project/models/users.dart';
import 'package:flutter_project/services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final firestoreService = FirestoreService();
  late String _email;
  late String _nickName;
  late String _position;

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

  loadValues(ApplicationUser user) {
    _email = user.email!;
    _nickName = user.nickName!;
    _position = user.position!;
  }

  saveUser() {
    var newUser =
        ApplicationUser(email: email, nickName: nickName, position: position);
    firestoreService.saveUser(newUser);
  }

  removeUser(String userId) {
    firestoreService.removeUser(userId);
  }
}
