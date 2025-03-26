import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({super.key});

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  TextEditingController famCodeController = TextEditingController();
  String? family_code;

  void accountCreated() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    famCodeController.addListener(() {
      setState(() {
        family_code = famCodeController.text;
      });
    });
  }

  @override
  void dispose() {
    famCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Link account')),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter your family code:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 400.0,
                      child: TextField(
                        controller: famCodeController,
                        decoration: InputDecoration(
                          hintText: 'Family code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.buttonTeal,
                        fixedSize: Size(250.0, 50.0),
                      ),
                      onPressed: () {
                        if (famCodeController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Enter a family code')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'You have successfully joined family $family_code!',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Link',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    SizedBox(height: 40.0),
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
