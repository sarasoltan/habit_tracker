import 'package:get_it/get_it.dart';
import 'package:project2/db/user_services.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/services/data_service.dart';
import 'package:project2/services/theme_service.dart';
import 'package:project2/views/home_page/home_page.dart';
import 'package:project2/views/Intro/introduction_animation_screen.dart';
import 'package:flutter/material.dart';
import 'package:project2/views/verify_email_view.dart';
import 'package:project2/widgets/life_cycle_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService.firebase().initialze();
  //await Firebase.initializeApp();

  final dataService = DataService();
  await dataService.init();
  GetIt.I.registerSingleton(dataService);

  final themeService = ThemeService();
  await themeService.init();
  GetIt.I.registerSingleton(themeService);

  WidgetsBinding.instance!.addObserver(LifeCycleHandler(
      resumeCallBack: () async =>
          themeService.updateThemeStatus(themeService.themeStatus)));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeService = GetIt.I.get<ThemeService>();
    return FutureBuilder(
        future: AuthService.firebase().initialze(),
        builder: (context, snapshot) {
          final user = AuthService.firebase().currentUser;
          if (isviewed != 0) {
            return StreamBuilder<ThemeData>(
                stream: themeService.theme.stream,
                initialData: themeService.theme.value,
                builder: (context, snapshot) {
                  return AnimatedTheme(
                    duration: const Duration(milliseconds: 500),
                    data: snapshot.data!,
                    child: MaterialApp(
                        theme: snapshot.data,
                        home: IntroductionAnimationScreen()),
                  );
                });
          } else {
            final themeService = GetIt.I.get<ThemeService>();

            return StreamBuilder<ThemeData>(
                stream: themeService.theme.stream,
                initialData: themeService.theme.value,
                builder: (context, snapshot) {
                  return AnimatedTheme(
                    duration: const Duration(milliseconds: 500),
                    data: snapshot.data!,
                    child: MaterialApp(theme: snapshot.data, home: HomePage()),
                  );
                });
          }
        });
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final themeService = GetIt.I.get<ThemeService>();
//     return FutureBuilder(
//       future: AuthService.firebase().initialze(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;

//             if (user != null) {
//               if (user.isEmailVerified) {
//                 //return const HomePage();
//                 // return HabitsDialog();
//                 return StreamBuilder<ThemeData>(
//                     stream: themeService.theme.stream,
//                     initialData: themeService.theme.value,
//                     builder: (context, snapshot) {
//                       return AnimatedTheme(
//                         duration: const Duration(milliseconds: 500),
//                         data: snapshot.data!,
//                         child: MaterialApp(
//                             theme: snapshot.data, home: const HomePage()),
//                       );
//                     });
//               } else {
//                 return VerifyEmailView();
//               }
//             } else {
//               return StreamBuilder<ThemeData>(
//                   stream: themeService.theme.stream,
//                   initialData: themeService.theme.value,
//                   builder: (context, snapshot) {
//                     return AnimatedTheme(
//                       duration: const Duration(milliseconds: 500),
//                       data: snapshot.data!,
//                       child: MaterialApp(
//                           theme: snapshot.data,
//                           home: const IntroductionAnimationScreen()),
//                     );
//                   });
//             }

//           default:
//             return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

