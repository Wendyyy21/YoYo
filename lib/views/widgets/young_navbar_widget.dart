import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class Young_NavBar extends StatefulWidget {
  const Young_NavBar({super.key});

  @override
  State<Young_NavBar> createState() => _Young_NavBarState();
}

class _Young_NavBarState extends State<Young_NavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, value, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
            NavigationDestination(icon: Icon(Icons.medication), label: 'Medicine'),

          ],
          onDestinationSelected: (value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: value,
        );
      },
    );
  }
}
