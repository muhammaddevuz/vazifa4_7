import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFiribaseServices{
  final userCollection=FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsers() async* {
    yield* userCollection.snapshots();
  }
  void addUser(String id, String email, int correctAnswer) {
  userCollection.doc(id).set({
    "email": email,
    "correctAnswer": correctAnswer,
  });
}

}