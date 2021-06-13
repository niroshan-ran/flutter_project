import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/users.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(ApplicationUser user) {
    return _db.collection('users').doc(user.email).set(user.toMap());
  }

  Stream<List<ApplicationUser>> getUsers(String email) {
    return _db
        .collection('users')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ApplicationUser.fromFirestore(document.data()))
            .toList());
  }

  Future<void> updateUser(ApplicationUser user) {
    return _db.collection('users').doc(user.email).update(user.toMap());
  }

  Future<void> removeUser(String email) {
    return _db.collection('users').doc(email).delete();
  }
}
