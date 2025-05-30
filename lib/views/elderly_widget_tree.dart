import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/elderly/chat_page.dart';
import 'package:frontend/views/pages/elderly/game_page.dart';
import 'package:frontend/views/pages/elderly/home_page.dart';
import 'package:frontend/views/pages/elderly/profile_page.dart';
import 'package:frontend/views/widgets/elderly_navbar_widget.dart';

List<Widget> pages = [
  Elderly_HomePage(),
  Elderly_ChatPage(),
  Elderly_GamePage(),
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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 7.0), // Adjust value as needed
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Elderly_ProfilePage();
                      },
                    ),
                  );
                },
                icon: Icon(Icons.person, size: 30.0),
              ),
            ),
          ],
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
