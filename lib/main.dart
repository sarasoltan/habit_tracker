import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/views/details.dart';
import 'package:project2/views/habits_view.dart';
import 'package:project2/views/introduction_animation_screen.dart';
import 'package:project2/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:project2/views/register_view.dart';
import 'package:project2/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      habitsRoute: (context) => habits_view(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialze(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              print(user);
              if (user.isEmailVerified) {
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
