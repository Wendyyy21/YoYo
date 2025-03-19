import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class Elderly_NavBar extends StatefulWidget {
  const Elderly_NavBar({super.key});

  @override
  State<Elderly_NavBar> createState() => _Elderly_NavBarState();
}

class _Elderly_NavBarState extends State<Elderly_NavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, value, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(
              icon: Icon(Icons.sports_esports),
              label: 'Play',
            ),
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
