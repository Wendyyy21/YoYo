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
  List<Map<String, dynamic>> members = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId;
  bool _isLoading = true;
  bool _noFamily = false;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
    _fetchFamilyData();
  }

  Future<void> _fetchFamilyData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Query the user's document to get the familyCode
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists &&
            userDoc.data()?.containsKey('familyCode') == true) {
          familyCode = userDoc.data()!['familyCode'];
          await _fetchFamilyMembers(familyCode!);
        } else {
          _noFamily = true;
        }
      }
    } catch (e) {
      print('Error fetching family data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchFamilyMembers(String familyCode) async {
    try {
      final familyDoc =
          await _firestore.collection('family').doc(familyCode).get();
      if (familyDoc.exists) {
        final familyData = familyDoc.data();
        members.clear();
        familyData?.forEach((key, value) {
          if (key.startsWith('member')) {
            _fetchMemberDetails(value);
          }
        });
      } else {
        _noFamily = true;
      }
    } catch (e) {
      print('Error fetching family members: $e');
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
            'name': memberData['username'] ?? 'Unknown',
            'role': memberData['role'] ?? 'young',
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
            await _firestore.collection('users').doc(user.uid).update({
              'familyCode': FieldValue.delete(),
            });
            Navigator.pop(context);
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
            if (familyCode != null)
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: _leaveFamily,
              ),
          ],
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _noFamily
                ? const Center(
                  child: Text(
                    'You are not in a family.',
                    style: TextStyle(fontSize: 18),
                  ),
                ) // Display no family message
                : Column(
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
                                member['role'] == 'elder'
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
                                    isCurrentUser
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    isCurrentUser ? Colors.blue : Colors.black,
                              ),
                            ),
                            tileColor:
                                isCurrentUser
                                    ? Colors.blue.withOpacity(0.1)
                                    : null,
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
