import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/young/home_page.dart';
import 'package:frontend/views/widgets/young_navbar_widget.dart';

List<Widget> pages = [Young_HomePage()];

class youngWidgetTree extends StatefulWidget {
  const youngWidgetTree({super.key});

  @override
  State<youngWidgetTree> createState() => youngWidgetTreeState();
}

class youngWidgetTreeState extends State<youngWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 193, 225, 193),
          title: const Text(
            'YoYo',
            style: TextStyle(
              fontFamily: 'SpicyRice',
              fontSize: 34.0,
              color: AppColors.titleGreen,
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, value, child) {
            return pages.elementAt(value);
          },
        ),
        bottomNavigationBar: young_NavBar(),
      ),
    );
  }
}
