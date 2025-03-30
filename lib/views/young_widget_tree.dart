import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/young/home_page.dart';
import 'package:frontend/views/pages/young/map_page.dart';
import 'package:frontend/views/pages/young/medicine_input_page.dart';
import 'package:frontend/views/pages/young/young_profile.dart';
import 'package:frontend/views/widgets/young_navbar_widget.dart';

List<Widget> pages = [Young_HomePage(), Young_MapPage(), Young_MedicinePage()];

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
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 7.0), // Adjust value as needed
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Young_ProfilePage();
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
        bottomNavigationBar: Young_NavBar(),
      ),
    );
  }
}
