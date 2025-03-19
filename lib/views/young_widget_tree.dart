import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/young/home_page.dart';
import 'package:frontend/views/pages/young/map_page.dart';
import 'package:frontend/views/pages/young/medicine_input_page.dart';
import 'package:frontend/views/widgets/young_navbar_widget.dart';

List<Widget> pages = [
  Young_HomePage(),
  Young_MapPage(),
  Young_MedicinePage(),
];

class YoungWidgetTree extends StatefulWidget {
  const YoungWidgetTree({super.key});

  @override
  State<YoungWidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<YoungWidgetTree> {
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
        bottomNavigationBar: Young_NavBar(),
      ),
    );
  }
}
