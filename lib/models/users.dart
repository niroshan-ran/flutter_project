class ApplicationUser {
  final String? email;
  final String? nickName;
  final String? position;

  ApplicationUser({this.email, this.nickName, this.position});

  Map<String, dynamic> toMap() {
    return {'email': email, 'nickName': nickName, 'position': position};
  }

  ApplicationUser.fromFirestore(Map<String, dynamic> firestore)
      : email = firestore['email'],
        nickName = firestore['nickName'],
        position = firestore['position'];
}
