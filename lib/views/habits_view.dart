import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project2/constants/routes.dart';
import 'package:project2/enums/menu_action.dart';

class habits_view extends StatelessWidget {
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
      body:
          // CalendarColumn(),
          // floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          //     Provider.of<Bloc>(context, listen: false).hideSnackBar();
          //     navigateToCreatePage(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          semanticLabel: 'Add',
          size: 35.0,
        ),
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
