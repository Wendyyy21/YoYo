import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/pages/accounttype_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController pwController1 = TextEditingController();
  bool _obscureText1 = true;
  TextEditingController pwController2 = TextEditingController();
  bool _obscureText2 = true;

  void validateInput(
    TextEditingController usernameController,
    TextEditingController pwController1,
    TextEditingController pwController2,
  ) {
    if (usernameController.text.trim().isEmpty ||
        pwController1.text.trim().isEmpty ||
        pwController2.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter all details.')));
      return;
    }
    if (pwController1.text != pwController2.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match.')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AccountTypePage();
        },
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwController1.dispose();
    pwController2.dispose();
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: pwController1,
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
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 350.0,
                    child: TextField(
                      controller: pwController2,
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
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.buttonTeal,
                      fixedSize: Size(250.0, 50.0),
                      side: BorderSide(color: AppColors.buttonTeal, width: 1.5),
                    ),
                    onPressed: () {
                      validateInput(
                        usernameController,
                        pwController1,
                        pwController2,
                      );
                    },
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
