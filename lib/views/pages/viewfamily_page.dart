import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewFamilyPage extends StatefulWidget {
  const ViewFamilyPage({super.key});

  @override
  State<ViewFamilyPage> createState() => _ViewFamilyPageState();
}

class _ViewFamilyPageState extends State<ViewFamilyPage> {
  String? familyCode;
  String? currentUserId;
  List<Map<String, dynamic>> members = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
    _fetchFamilyData();
  }

  Future<void> _fetchFamilyData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final familyQuery =
          await _firestore
              .collection('family')
              .where('member1', isEqualTo: user.uid)
              .get();

      if (familyQuery.docs.isNotEmpty) {
        final familyDoc = familyQuery.docs.first;
        familyCode = familyDoc.id;

        final familyData = familyDoc.data();
        members.clear(); // Clear existing member data
        familyData.forEach((key, value) {
          if (key.startsWith('member')) {
            _fetchMemberDetails(value);
          }
        });
      } else {
        // Handle case where user is not in a family
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not in a family.')),
        );
      }
    }
  }

  Future<void> _fetchMemberDetails(String memberUid) async {
    try {
      final memberDoc =
          await _firestore.collection('users').doc(memberUid).get();
      if (memberDoc.exists) {
        final memberData = memberDoc.data() as Map<String, dynamic>;
        setState(() {
          members.add({
            'uid': memberUid,
            'name':
                memberData['username'] ?? 'Unknown', // Corrected to 'username'
            'role': memberData['role'] ?? 'young', // Corrected to 'role'
          });
        });
      } else {
        print('User document not found for UID: $memberUid');
        setState(() {
          members.add({'uid': memberUid, 'name': 'Unknown', 'role': 'young'});
        });
      }
    } catch (e) {
      print('Error fetching member details: $e');
      setState(() {
        members.add({'uid': memberUid, 'name': 'Unknown', 'role': 'young'});
      });
    }
  }

  Future<void> _leaveFamily() async {
    final user = _auth.currentUser;
    if (user != null && familyCode != null) {
      try {
        final familyDoc =
            await _firestore.collection('family').doc(familyCode).get();
        if (familyDoc.exists) {
          final familyData = familyDoc.data() as Map<String, dynamic>;
          String memberKeyToRemove = '';
          familyData.forEach((key, value) {
            if (value == user.uid) {
              memberKeyToRemove = key;
            }
          });
          if (memberKeyToRemove.isNotEmpty) {
            await _firestore.collection('family').doc(familyCode).update({
              memberKeyToRemove: FieldValue.delete(),
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have left the family.')),
            );
            Navigator.pop(context); // Go back to previous screen
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are not in this family.')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error leaving family: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Family'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _leaveFamily,
            ),
          ],
        ),
        body: Column(
          children: [
            if (familyCode != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Family Code: $familyCode',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isCurrentUser = member['uid'] == currentUserId;
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: AssetImage(
                        member['role'] ==
                                'elder' // Corrected to 'elder'
                            ? 'assets/images/elderly_avatar.png'
                            : 'assets/images/young_avatar.png',
                      ),
                      radius: 30.0,
                    ),
                    title: Text(
                      member['name'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight:
                            isCurrentUser ? FontWeight.bold : FontWeight.normal,
                        color: isCurrentUser ? Colors.blue : Colors.black,
                      ),
                    ),
                    tileColor:
                        isCurrentUser ? Colors.blue.withOpacity(0.1) : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
