import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vazifa/services/quiz_firebase_services.dart';

class QuizController extends ChangeNotifier {
  final QuizFirebaseServices quizFirebaseServices = QuizFirebaseServices();

  Stream<QuerySnapshot> getQuizes() {
    return quizFirebaseServices.getQuizes();
  }

  void addQuiz(String question, String option1, String option2, String option3,
      int correctIndex) {
    quizFirebaseServices.addQuiz(
        question, option1, option2, option3, correctIndex);
  }

  void editQuiz(String id, String question, String option1, String option2,
      String option3, int correctIndex) {
    quizFirebaseServices.editQuiz(
        id, question, option1, option2, option3, correctIndex);
  }
}
