import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class young_NavBar extends StatefulWidget {
  const young_NavBar({super.key});

  @override
  State<young_NavBar> createState() => _young_NavBarState();
}

class _young_NavBarState extends State<young_NavBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, value, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
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
