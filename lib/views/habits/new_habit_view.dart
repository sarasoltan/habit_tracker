import 'package:flutter/material.dart';

class NewHabitView extends StatelessWidget {
  const NewHabitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("new habit"),
      ),
      body: const Text("Write your text here..."),
    );
  }
}
