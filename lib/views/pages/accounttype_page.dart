import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/views/elderly_widget_tree.dart';
import 'package:frontend/views/young_widget_tree.dart';
import 'package:frontend/views/widgets/accounttype_widget.dart';

class AccountTypePage extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AccountTypePage({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  int? selectedType; // 0 for elderly, 1 for young

  void onTypeSelected(int type) {
    setState(() {
      selectedType = type;
    });
  }

  void validateAccountType() async {
    if (selectedType == 0 || selectedType == 1) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: widget.email,
              password: widget.password,
            );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'email': widget.email,
              'uid': userCredential.user!.uid,
              'role': selectedType == 0 ? 'elder' : 'younger',
              'username': widget.username,
            });

        if (selectedType == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ElderlyWidgetTree()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => youngWidgetTree()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save role: ${e.message}')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select an account type')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Create an account')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select account type',
                  style: TextStyle(fontSize: 30.0),
                ),
                const SizedBox(height: 20.0),
                AccountTypeWidget(
                  imagePath: 'assets/images/elderly_avatar.png',
                  text: "I'm an\nelderly user",
                  type: 0,
                  isSelected: selectedType == 0,
                  onSelect: onTypeSelected,
                ),
                const SizedBox(width: 30.0),
                AccountTypeWidget(
                  imagePath: 'assets/images/young_avatar.png',
                  text: "I'm a\nyoung user",
                  type: 1,
                  isSelected: selectedType == 1,
                  onSelect: onTypeSelected,
                ),
                const SizedBox(height: 20.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.buttonTeal,
                    fixedSize: Size(250.0, 50.0),
                    side: BorderSide(color: AppColors.buttonTeal, width: 1.5),
                  ),
                  onPressed: () {
                    validateAccountType();
                  },
                  child: const Text('Next', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
