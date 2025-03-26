import 'package:flutter/material.dart';
import 'package:frontend/views/pages/changepw_page.dart';
import 'package:frontend/views/pages/linkaccount_page.dart';
import 'package:frontend/views/pages/viewfamily_page.dart';
import 'package:frontend/views/pages/welcome_page.dart';

class Elderly_ProfilePage extends StatefulWidget {
  const Elderly_ProfilePage({super.key});

  @override
  State<Elderly_ProfilePage> createState() => _Elderly_ProfilePageState();
}

class _Elderly_ProfilePageState extends State<Elderly_ProfilePage> {
  TextEditingController usernameController = TextEditingController(
    text: 'Grandma',
  );
  //TODO: replace with actual username
  final String id = 'isubfoufoua';
  //TODO: replace with actual ID

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

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
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                style: TextStyle(fontSize: 40.0),
                textAlign: TextAlign.center,
              ),
            ),
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
                    title: Text('Change password'),
                    leading: Icon(Icons.security),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChangePasswordPage();
                          },
                        ),
                      );
                    },
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
                    title: Text('View family'),
                    leading: Icon(Icons.family_restroom),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewFamilyPage();
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
