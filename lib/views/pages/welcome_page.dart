import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/pages/login_page.dart';
import 'package:frontend/views/pages/register_page.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/views/elderly_widget_tree.dart';
import 'package:frontend/views/young_widget_tree.dart';
import 'package:frontend/data/notifiers.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String role = userDoc.get('role');

        if (role == 'elder') {
          selectedPageNotifier.value = 0;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ElderlyWidgetTree()),
          );
        } else {
          selectedPageNotifier.value = 0;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const YoungWidgetTree()),
          );
        }
      } catch (e) {
        print('Error navigating after login: $e');
      }
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Add this function to show licenses
  void _showLicensePage() {
    showLicensePage(
      context: context,
      applicationName: "YoYo", 
      applicationVersion: "1.0", 
      applicationLegalese: "Copyright © ${DateTime.now().year} Petrichor 4.0",
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlutterLogo(size: 32), // Replace with your app icon if needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            _navigateToLogin();
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'YoYo',
                          style: TextStyle(
                            fontSize: 80.0,
                            fontFamily: 'SpicyRice',
                            color: AppColors.titleGreen,
                          ),
                        ),
                        Lottie.asset(
                          'assets/lotties/welcome_page.json',
                          height: 200.0,
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.buttonTeal,
                            foregroundColor: Colors.white,
                            fixedSize: const Size(250.0, 50.0),
                          ),
                          onPressed: _navigateToLogin,
                          child: const Text(
                            'Log In',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.buttonTeal,
                            fixedSize: const Size(250.0, 50.0),
                            side: BorderSide(
                              color: AppColors.buttonTeal,
                              width: 1.5,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.buttonTeal,
                  foregroundColor: Colors.white,
                  onPressed: _showLicensePage,
                  child: const Icon(Icons.copyright),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}