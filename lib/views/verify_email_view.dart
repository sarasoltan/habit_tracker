import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/views/register_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(
        children: [
          const Text("We've sent you an email verification"),
          const Text("if you haven't received, press the button below"),
          TextButton(
            onPressed: () async {
              AuthService.firebase().currentUser;
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("send email verification"),
          ),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => RegisterView()));
                // Navigator.of(context)
                //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("restart"))
        ],
      ),
    );
  }
}
