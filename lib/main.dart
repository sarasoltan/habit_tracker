import 'package:project2/firebase_options.dart';
import 'package:project2/views/details.dart';
import 'package:project2/views/habits_view.dart';
import 'package:project2/views/introduction_animation_screen.dart';
import 'package:project2/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/views/register_view.dart';
import 'package:project2/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/details/': (context) => details(),
      '/habits/': (context) => habits_view(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              print(user);
              if (user.emailVerified) {
                return habits_view();
              } else {
                return VerifyEmailView();
              }
            } else {
              return IntroductionAnimationScreen();
            }

          default:
            return IntroductionAnimationScreen();
        }
      },
    );
  }
}
