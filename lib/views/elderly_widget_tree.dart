import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/elderly/chat_page.dart';
import 'package:frontend/views/pages/elderly/home_page.dart';
import 'package:frontend/views/pages/elderly/profile_page.dart';
import 'package:frontend/views/widgets/elderly_navbar_widget.dart';

List<Widget> pages = [
  Elderly_HomePage(),
  Elderly_ChatPage(),
  Elderly_ProfilePage(),
];

class ElderlyWidgetTree extends StatefulWidget {
  const ElderlyWidgetTree({super.key});

  @override
  State<ElderlyWidgetTree> createState() => _ElderlyWidgetTreeState();
}

class _ElderlyWidgetTreeState extends State<ElderlyWidgetTree> {
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
        bottomNavigationBar: Elderly_NavBar(),
      ),
    );
  }
}
