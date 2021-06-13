class User {
  final String userId;
  final String email;
  final String nickName;
  final String position;

  User(
      {required this.userId,
      required this.email,
      required this.nickName,
      required this.position});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'nickName': nickName,
      'position': position
    };
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        email = firestore['email'],
        nickName = firestore['nickName'],
        position = firestore['position'];
}
