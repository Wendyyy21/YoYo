import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/elderly_widget_tree.dart';
import 'package:frontend/views/young_widget_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  bool _obscureText = true;
  
  // Add focus nodes
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  Future<void> validateInput(
    TextEditingController usernameController,
    TextEditingController pwController,
  ) async {
    if (usernameController.text.trim().isEmpty ||
        pwController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter all details.')));
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: usernameController.text.trim(),
            password: pwController.text.trim(),
          );

      // Retrieve user role from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      String role = userDoc.get('role');

      // Navigate based on role
      if (role == 'elder') {
        selectedPageNotifier.value = 0;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ElderlyWidgetTree()),
          (route) => false,
        );
      } else {
        selectedPageNotifier.value = 0;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => YoungWidgetTree()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login: Incorrect email or password.'),
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: Invalid email format.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${e.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 80.0,
                    fontFamily: 'SpicyRice',
                    color: AppColors.titleGreen,
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 350.0,
                  child: TextField(
                    controller: usernameController,
                    focusNode: emailFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      // Move focus to password field when Enter is pressed
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 350.0,
                  child: TextField(
                    controller: pwController,
                    focusNode: passwordFocusNode,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) {
                      // Submit the form when Enter is pressed in password field
                      validateInput(usernameController, pwController);
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.buttonTeal,
                    foregroundColor: Colors.white,
                    fixedSize: Size(250.0, 50.0),
                  ),
                  onPressed: () {
                    validateInput(usernameController, pwController);
                  },
                  child: const Text('Log In', style: TextStyle(fontSize: 20.0)),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}