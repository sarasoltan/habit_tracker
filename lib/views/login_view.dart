import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/services/auth/auth_exceptions.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/services/theme_service.dart';
import 'package:project2/utilities/show_error_dialog.dart';
import 'package:project2/views/FadeAnimation.dart';
import 'package:project2/views/home_page/home_page.dart';
import 'package:project2/views/register_view.dart';
import 'package:project2/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = GetIt.I.get<ThemeService>();
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(title: const Text("login")),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom:
                                        BorderSide(color: (Colors.grey[100])!),
                                  )),
                                  child: TextField(
                                    controller: _email,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email ",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _password,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2,
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: TextButton(
                                onPressed: () async {
                                  final email = _email.text;
                                  final password = _password.text;
                                  try {
                                    await AuthService.firebase().logIn(
                                        email: email, password: password);
                                    final user =
                                        AuthService.firebase().currentUser;

                                    if (user?.isEmailVerified ?? false) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (ctx) {
                                        return StreamBuilder<ThemeData>(
                                            stream: themeService.theme.stream,
                                            initialData:
                                                themeService.theme.value,
                                            builder: (context, snapshot) {
                                              return AnimatedTheme(
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                data: snapshot.data!,
                                                child: MaterialApp(
                                                    theme: snapshot.data,
                                                    home: const HomePage()),
                                              );
                                            });
                                      }));
                                      // Navigator.of(context)
                                      //     .pushNamedAndRemoveUntil(
                                      //         homePageRoute, (route) => false);

                                      // Navigator.of(context)
                                      //     .pushNamedAndRemoveUntil(
                                      //         habitsRoute, (route) => false);
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  VerifyEmailView()));
                                      // Navigator.of(context)
                                      //     .pushNamedAndRemoveUntil(
                                      //         verifyEmailRoute,
                                      //         (route) => false);
                                    }
                                  } on UserNotFoundAuthException {
                                    await showErrorDialog(
                                        context, "User not found!");
                                  } on WrongPasswordAuthException {
                                    await showErrorDialog(context,
                                        "You have entered a wrong password!");
                                  } on GenericAuthException {
                                    await showErrorDialog(
                                        context, 'Authentication Error');
                                  }
                                  //'Authentication Error'
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                          1.5,
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => RegisterView()));

                                // Navigator.of(context).pushNamedAndRemoveUntil(
                                //   registerRoute,
                                //   (route) => false,
                                // );
                              },
                              child: const Text(
                                "Not registered yet? register here!",
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              ))),
                      FadeAnimation(
                          1.5,
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
