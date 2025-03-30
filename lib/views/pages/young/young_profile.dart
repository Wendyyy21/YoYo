import 'package:flutter/material.dart';
import 'package:frontend/views/pages/changepw_page.dart';
import 'package:frontend/views/pages/linkaccount_page.dart';
import 'package:frontend/views/pages/viewfamily_page.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Young_ProfilePage extends StatefulWidget {
  const Young_ProfilePage({super.key});

  @override
  State<Young_ProfilePage> createState() => _Young_ProfilePageState();
}

class _Young_ProfilePageState extends State<Young_ProfilePage> {
  String userId = '';
  String username = 'Loading...';
  String userRole = 'young';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
        if (userDoc.exists) {
          setState(() {
            username = userDoc.data()?['username'] ?? 'Username not found';
            userRole = userDoc.data()?['role'] ?? 'young';
          });
        } else {
          setState(() {
            username = 'User data not found';
          });
        }
      } else {
        setState(() {
          username = 'User not logged in';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        username = 'Error loading username';
      });
    }
  }

  Future<void> _copyUserId() async {
    await Clipboard.setData(ClipboardData(text: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account ID copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              foregroundImage: AssetImage(
                userRole == 'elder'
                    ? 'assets/images/elderly_avatar.png'
                    : 'assets/images/young_avatar.png',
              ),
              radius: 100.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              username,
              style: const TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Account ID:',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copyUserId,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Change password'),
                    leading: const Icon(Icons.security),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ChangePasswordPage();
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Link account'),
                    leading: const Icon(Icons.link),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LinkAccountPage();
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('View family'),
                    leading: const Icon(Icons.family_restroom),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ViewFamilyPage();
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Log out'),
                    leading: const Icon(Icons.logout),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const WelcomePage();
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