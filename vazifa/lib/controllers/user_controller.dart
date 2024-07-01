import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vazifa/services/users_firibase_services.dart';

class UserController extends ChangeNotifier {
  final UsersFiribaseServices quizFirebaseServices = UsersFiribaseServices();

  Stream<QuerySnapshot> getUsers() {
    return quizFirebaseServices.getUsers();
  }

  void addUser(String id, String email, int correctAnswer) {
    quizFirebaseServices.addUser(id, email,  correctAnswer);
  }


}
