import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vazifa/controllers/user_controller.dart';
import 'package:vazifa/models/user.dart';
import 'package:vazifa/views/screens/login_screen.dart';
import 'package:vazifa/views/screens/main_screen.dart';

// ignore: must_be_immutable
class FinalScreen extends StatefulWidget {
  int correctAnsver;
  FinalScreen({super.key, required this.correctAnsver});

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  Future<void> _updateUserScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final currentUserData = docSnapshot.data() as Map<String, dynamic>;
        final previousCorrectAnswer = currentUserData['correctAnswer'] as int;
        final updatedCorrectAnswer =
            previousCorrectAnswer + widget.correctAnsver;

        await userDoc.update({'correctAnswer': updatedCorrectAnswer});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _updateUserScore();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.watch<UserController>();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const LoginScreen();
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              backgroundColor: Colors.purple,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Correct Answer: ${widget.correctAnsver}",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: userController.getUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final users = snapshot.data!.docs;
                          users.sort((a, b) =>
                              b['correctAnswer'].compareTo(a['correctAnswer']));
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = Users.fromJson(users[index]);
                              return ListTile(
                                leading: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                ),
                                title: Text(
                                  "User: ${user.email}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "Correct answer: ${user.correctAnswer}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
