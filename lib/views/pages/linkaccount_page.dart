import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:lottie/lottie.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({super.key});

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  TextEditingController idController = TextEditingController();
  String? link_id;
  String user_id =
      'DB38562472'; // TODO: replace with an automatically generated ID

  void linkAccount() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 320.0,
            width: 300.0,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Text(
                          'A request has been sent to \nthe account $link_id',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Text(
                          '\nWaiting for user to accept...',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 64.0),
                        Text(
                          'Note: Click "Accept" on the device with the account $link_id to confirm linking to this account.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 6.0),
                        Lottie.asset('assets/lotties/loading.json'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    requestAccepted();
  }

  void requestAccepted() {
    Future.delayed(Duration(seconds: 5), () {
      // TODO: replace with other user accepting the request
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request accepted!')));
      Future.delayed(Duration(seconds: 2), () {
        accountCreated();
      });
    });
  }

  void accountCreated() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Account created successfully!')));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return WelcomePage();
        },
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    idController.addListener(() {
      setState(() {
        link_id = idController.text;
      });
    });
  }

  @override
  void dispose() {
    idController.dispose();
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
                      'Enter the ID of the account you wish to be linked to:',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Your ID is: $user_id',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 400.0,
                      child: TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          hintText: 'Account ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.buttonTeal,
                        fixedSize: Size(250.0, 50.0),
                      ),
                      onPressed: () {
                        accountCreated();
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.buttonTeal,
                        fixedSize: Size(250.0, 50.0),
                      ),
                      onPressed: () {
                        idController.text.trim().isEmpty
                            ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enter an account ID')),
                            )
                            : linkAccount();
                      },
                      child: const Text(
                        'Link',
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
