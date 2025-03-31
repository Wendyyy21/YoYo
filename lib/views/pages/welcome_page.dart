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
      // User is logged in, navigate to the appropriate screen
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        String role = userDoc.get('role');

        if (role == 'elder') {
          selectedPageNotifier.value = 0;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ElderlyWidgetTree()),
          );
        } else {
          selectedPageNotifier.value = 0;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => YoungWidgetTree()),
          );
        }
      } catch (e) {
        // Handle any errors during navigation
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
          body: GestureDetector(
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
        ),
      ),
    );
  }
}
