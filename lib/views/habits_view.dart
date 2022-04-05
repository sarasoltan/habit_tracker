import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/enums/menu_action.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/services/crud/habits_services.dart';

class HabitsView extends StatefulWidget {
  const HabitsView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HabitsViewState();
}

class _HabitsViewState extends State<HabitsView> {
  late final HabitsService _habitsService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

//initState is only availble in Stateful widget
//open the database
  @override
  void initState() {
    _habitsService = HabitsService();
    super.initState();
  }

  @override
  void dispose() {
    _habitsService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // (!Provider.of<Bloc>(context).getSeenOnboarding)
        //     ? OnBoardingScreen()
        //    :
        Scaffold(
      appBar: AppBar(
        title: Text(
          "Habits",
          style: Theme.of(context).textTheme.headline5,
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                )
              ];
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.bar_chart,
              semanticLabel: 'Statistics',
            ),
            color: Colors.grey[400],
            tooltip: 'Statistics',
            onPressed: () {
              // Provider.of<Bloc>(context, listen: false).hideSnackBar();
              // navigateToStatisticsPage(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              semanticLabel: 'Settings',
            ),
            color: Colors.grey[400],
            tooltip: 'Settings',
            onPressed: () {
              //               Provider.of<Bloc>(context, listen: false).hideSnackBar();
              //                navigateToSettingsPage(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _habitsService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _habitsService.allHabits,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text("waiting for all notes...");
                      default:
                        return const CircularProgressIndicator();
                    }
                  });
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to signout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Logout"),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
