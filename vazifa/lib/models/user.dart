import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String id;
  String email;
  int correctAnswer;

  Users({
    required this.id,
    required this.email,
    required this.correctAnswer,
  });

  factory Users.fromJson(QueryDocumentSnapshot query) {
    return Users(
      id: query.id,
      email: query['email'],
      correctAnswer: query['correctAnswer'],
    );
  }
}
