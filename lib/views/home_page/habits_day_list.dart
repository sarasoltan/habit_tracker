import 'package:flutter/material.dart';
import 'package:project2/services/data_service.dart';
import 'package:project2/views/home_page/home_page_controller.dart';
import 'package:project2/widgets/my_checkbox.dart';
import 'package:provider/provider.dart';

class HabitsDayList extends StatefulWidget {
  const HabitsDayList({Key? key}) : super(key: key);

  @override
  State<HabitsDayList> createState() => _HabitsDayListState();
}

class _HabitsDayListState extends State<HabitsDayList> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomePageController>(context);

    return StreamBuilder<int>(
        stream: controller.selectedDayindex.stream,
        initialData: controller.selectedDayindex.value,
        builder: (context, snapshot) {
          final dayIndex = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: controller.days[dayIndex].habits.length,
            itemBuilder: (ctx, i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                        controller
                                .habits[controller.days[dayIndex].habits.keys
                                    .elementAt(i)]
                                ?.emoji ??
                            "‽",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Theme.of(context).primaryColorDark)),
                  ),
                  Expanded(
                    child: Text(controller
                            .habits[controller.days[dayIndex].habits.keys
                                .elementAt(i)]
                            ?.text ??
                        ""),
                  ),
                  MyCheckbox(
                      initValue: controller.days[dayIndex].habits[controller
                              .days[dayIndex].habits.keys
                              .elementAt(i)] ??
                          false,
                      onChange: (newValue) => controller.updateHabitCheck(
                          dayIndex,
                          controller.days[dayIndex].habits.keys.elementAt(i),
                          newValue))
                ],
              );
            },
            separatorBuilder: (ctx, i) => Divider(indent: 30, endIndent: 30),
          );
        });
  }
}
