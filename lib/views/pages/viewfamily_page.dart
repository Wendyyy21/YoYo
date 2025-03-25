import 'package:flutter/material.dart';

class ViewFamilyPage extends StatelessWidget {
  const ViewFamilyPage({super.key});
  final int famCount = 3;

  static const List<List<String>> members = [
    ['Elderly', 'Grandma'],
    ['Young', 'Child1'],
    ['Young', 'Child2'],
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('View family')),
        body: ListView(
          children: List.generate(famCount, (index) {
            return Column(
              children: [
                SizedBox(height: 10.0),
                SizedBox(
                  height: 80.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      foregroundImage: AssetImage(
                        members[index][0] == 'Elderly'
                            ? 'assets/images/elderly_avatar.png'
                            : 'assets/images/young_avatar.png',
                      ),
                      radius: 30.0,
                    ),
                    title: Text(
                      members[index][1],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
