import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/pages/login_page.dart';
import 'package:frontend/views/pages/register_page.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                Lottie.asset('assets/lotties/welcome_page.json', height: 200.0),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.buttonTeal,
                    foregroundColor: Colors.white,
                    fixedSize: Size(250.0, 50.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage();
                        },
                      ),
                    );
                  },
                  child: const Text('Log In', style: TextStyle(fontSize: 20.0)),
                ),
                const SizedBox(height: 18.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.buttonTeal,
                    fixedSize: Size(250.0, 50.0),
                    side: BorderSide(color: AppColors.buttonTeal, width: 1.5),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterPage();
                        },
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
    );
  }
}
