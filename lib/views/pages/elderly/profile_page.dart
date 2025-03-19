import 'package:flutter/material.dart';
import 'package:frontend/views/pages/linkaccount_page.dart';
import 'package:frontend/views/pages/welcome_page.dart';

class Elderly_ProfilePage extends StatelessWidget {
  const Elderly_ProfilePage({super.key});
  final String username = 'Elderly'; //TODO: replace with actual username
  final String id = 'isubfoufoua'; //TODO: replace with actual ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              foregroundImage: AssetImage('assets/images/elderly_avatar.png'),
              radius: 100.0,
            ),
            SizedBox(height: 10.0),
            Text(username, style: TextStyle(fontSize: 40.0)),
            SizedBox(height: 10.0),
            Text(
              'Account ID: $id',
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Edit profile'),
                    leading: Icon(Icons.edit),
                  ),
                  ListTile(
                    title: Text('Link account'),
                    leading: Icon(Icons.link),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LinkAccountPage();
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Log out'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomePage();
                          },
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
