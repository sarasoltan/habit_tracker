import 'package:flutter/material.dart';
import 'package:project2/services/auth/auth_service.dart';
import 'package:project2/db/user_services.dart';
import 'package:project2/views/home_page/calendar.dart';
import 'package:project2/views/home_page/day_box.dart';
import 'package:project2/views/home_page/habits_day_list.dart';
import 'package:project2/views/home_page/home_page_controller.dart';
import 'package:project2/views/home_page/month_row.dart';
import 'package:project2/views/home_page/top_bar.dart';
import 'package:project2/widgets/circular_button.dart';
import 'package:provider/provider.dart';

import 'day_box.dart';
import 'habits_day_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserService _userService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

//initState is only availble in Stateful widget
  @override
  void initState() {
    _userService = UserService();
    super.initState();
  }

  @override
  void dispose() {
    _userService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          return Provider(
            create: (ctx) => HomePageController(),
            dispose: (ctx, HomePageController controller) =>
                controller.dispose(),
            builder: (ctx, child) =>
                Consumer<HomePageController>(builder: (ctx, controller, child) {
              return Scaffold(
                  body: SafeArea(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopBar(),
                  MonthRow(),
                  SizedBox(child: Calendar()),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 35, right: 35, left: 35, bottom: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColorLight),
                            padding: const EdgeInsets.only(top: 35),
                            child: HabitsDayList(),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            top: 0,
                            width: 70,
                            height: 70,
                            child: DayBox()),
                        Positioned(
                            right: 0,
                            top: 0,
                            width: 70,
                            height: 70,
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor),
                                child: CircularButton(
                                  onPressed: () =>
                                      controller.showHabitsDialog(context),
                                  icon: Icon(Icons.list),
                                )))
                      ],
                    ),
                  ))
                ],
              )));
            }),
          );
        });
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
