import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vazifa/controllers/quiz_controller.dart';
import 'package:vazifa/controllers/user_controller.dart';
import 'package:vazifa/firebase_options.dart';
import 'package:vazifa/views/screens/login_screen.dart';
import 'package:vazifa/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return QuizController();
          }),
          ChangeNotifierProvider(create: (context) {
            return UserController();
          })
        ],
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoginScreen();
                  }
                  return MainScreen();
                }),
          );
        });
  }
}
