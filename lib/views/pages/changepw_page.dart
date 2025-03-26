import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentPwController = TextEditingController();
  TextEditingController newPwController1 = TextEditingController();
  TextEditingController newPwController2 = TextEditingController();

  bool _obscureTextCurrent = true;
  bool _obscureTextNew1 = true;
  bool _obscureTextNew2 = true;

  @override
  void dispose() {
    currentPwController.dispose();
    newPwController1.dispose();
    newPwController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Change password')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your current and new password:',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: currentPwController,
                  decoration: InputDecoration(
                    hintText: 'Enter your current password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureTextCurrent = !_obscureTextCurrent;
                        });
                      },
                      icon: Icon(
                        _obscureTextCurrent
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureTextCurrent,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: newPwController1,
                  decoration: InputDecoration(
                    hintText: 'Enter your new password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureTextNew1 = !_obscureTextNew1;
                        });
                      },
                      icon: Icon(
                        _obscureTextNew1
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureTextNew1,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: newPwController2,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your new password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureTextNew2 = !_obscureTextNew2;
                        });
                      },
                      icon: Icon(
                        _obscureTextNew2
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureTextNew2,
                ),
              ),
              SizedBox(height: 20.0),
              FilledButton(
                onPressed: () {
                  if (currentPwController.text.isEmpty ||
                      newPwController1.text.isEmpty ||
                      newPwController2.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter all details!')),
                    );
                  }
                  //TODO: check with actual password from database
                  else if (currentPwController.text != '111') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Incorrect current password entered!'),
                      ),
                    );
                  } else if (newPwController1.text != newPwController2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('New passwords do not match!')),
                    );
                  } else {
                    //TODO: update password
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password successfully updated!')),
                    );
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
