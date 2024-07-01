import 'package:flutter/material.dart';
import 'package:vazifa/services/firebase_auth_services.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final firebaseAuthServices = FirebaseAuthServices();
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parolni Qayta Tiklash"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(
              size: 90,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Elektron pochta",
                  errorText: emailError),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                if (emailController.text.isEmpty) {
                  emailError = "Email kiriting";
                  setState(() {});
                } else {
                  firebaseAuthServices.resetPasword(emailController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
