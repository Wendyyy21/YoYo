import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/views/pages/accounttype_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwController1 = TextEditingController();
  bool _obscureText1 = true;
  TextEditingController pwController2 = TextEditingController();
  bool _obscureText2 = true;
  
  // Add focus nodes
  FocusNode emailFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode password1FocusNode = FocusNode();
  FocusNode password2FocusNode = FocusNode();

  Future<void> _register() async {
    if (pwController1.text != pwController2.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwController1.text.trim(),
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountTypePage(
            email: emailController.text.trim(),
            password: pwController1.text.trim(),
            username: usernameController.text.trim(),
          ),
        ),
      );

      if (result != null) {
        Navigator.pop(context, {
          'email': emailController.text.trim(),
          'password': pwController1.text.trim(),
          'username': usernameController.text.trim(),
          'role': result,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: ${e.message}')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    pwController1.dispose();
    pwController2.dispose();
    // Dispose focus nodes
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    password1FocusNode.dispose();
    password2FocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Create an account')),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      color: AppColors.titleGreen,
                      fontSize: 80.0,
                      fontFamily: 'SpicyRice',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(usernameFocusNode);
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: usernameController,
                      focusNode: usernameFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(password1FocusNode);
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: pwController1,
                      focusNode: password1FocusNode,
                      obscureText: _obscureText1,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText1 = !_obscureText1;
                            });
                          },
                          icon: Icon(
                            _obscureText1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(password2FocusNode);
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: pwController2,
                      focusNode: password2FocusNode,
                      obscureText: _obscureText2,
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText2 = !_obscureText2;
                            });
                          },
                          icon: Icon(
                            _obscureText2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) {
                        _register();
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.buttonTeal,
                      fixedSize: Size(250.0, 50.0),
                      side: BorderSide(color: AppColors.buttonTeal, width: 1.5),
                    ),
                    onPressed: _register,
                    child: const Text('Next', style: TextStyle(fontSize: 20.0)),
                  ),
                  const SizedBox(height: 160.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}