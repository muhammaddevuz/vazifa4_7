import 'package:firebase_auth/firebase_auth.dart';
import 'package:vazifa/controllers/user_controller.dart';
import 'package:vazifa/utils/current_user.dart';

class FirebaseAuthServices {
  UserController userController = UserController();
  Future<void> signIn(String email, String password) async {
    final box = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    CurrentUser.id = box.user!.uid;
  }

  Future<void> signUp(String email, String pasword) async {
    try {
      final box = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pasword);
      userController.addUser(box.user!.uid, email, 0);
    } catch (e) {
      return;
    }
  }

  Future<void> resetPasword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
  }
}
