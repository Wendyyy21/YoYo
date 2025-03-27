import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({super.key});

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  TextEditingController famCodeController = TextEditingController();
  String? family_code;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void accountCreated() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(context);
  }

  Future<String> generateFamilyCode() async {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    String familyCode;
    bool codeExists;

    do {
      familyCode = String.fromCharCodes(
        Iterable.generate(
          6,
          (_) => chars.codeUnitAt(random.nextInt(chars.length)),
        ),
      );

      // Check if the code already exists in Firestore
      final familyDoc =
          await _firestore.collection('family').doc(familyCode).get();
      codeExists = familyDoc.exists;
    } while (codeExists); // Repeat until a unique code is found

    return familyCode;
  }

  Future<void> createFamily() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final familyCode =
            await generateFamilyCode(); // Await the async function
        // Check if user is already in a family
        final userFamilyQuery =
            await _firestore.collection('users').doc(user.uid).get();

        if (userFamilyQuery.exists &&
            userFamilyQuery.data()?.containsKey('familyCode') == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User is already in a family.')),
          );
          return;
        }

        await _firestore.collection('family').doc(familyCode).set({
          'member1': user.uid,
        });

        await _firestore.collection('users').doc(user.uid).update({
          'familyCode': familyCode,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Family created with code: $familyCode')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating family: $e')));
    }
  }

  Future<void> linkAccount() async {
    if (famCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a family code')));
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final familyDoc =
            await _firestore
                .collection('family')
                .doc(famCodeController.text)
                .get();

        if (familyDoc.exists) {
          final familyData = familyDoc.data() as Map<String, dynamic>;

          if (familyData.values.contains(user.uid)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User is already in this family.')),
            );
            return;
          }

          final userFamilyQuery =
              await _firestore.collection('users').doc(user.uid).get();

          if (userFamilyQuery.exists &&
              userFamilyQuery.data()?.containsKey('familyCode') == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User is already in a family.')),
            );
            return;
          }

          int memberCount = 1;

          while (familyData.containsKey('member$memberCount')) {
            memberCount++;
          }

          await _firestore
              .collection('family')
              .doc(famCodeController.text)
              .update({'member$memberCount': user.uid});

          await _firestore.collection('users').doc(user.uid).update({
            'familyCode': famCodeController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You have successfully joined family ${famCodeController.text}!',
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Family code not found')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error linking account: $e')));
    }
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
        appBar: AppBar(title: const Text('Link account')),
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
                        decoration: const InputDecoration(
                          hintText: 'Family code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.buttonTeal,
                        fixedSize: const Size(250.0, 50.0),
                      ),
                      onPressed: linkAccount,
                      child: const Text(
                        'Link',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(250.0, 50.0),
                      ),
                      onPressed: createFamily,
                      child: const Text(
                        'Create Family',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    const SizedBox(height: 40.0),
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
