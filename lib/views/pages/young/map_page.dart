import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/data/constants.dart';
import 'dart:async';

class Young_MapPage extends StatefulWidget {
  const Young_MapPage({super.key});

  @override
  State<Young_MapPage> createState() => _YoungMapState();
}

class _YoungMapState extends State<Young_MapPage> {
  String? _selectedElderly;
  List<String> _elderlyList = [];
  LatLng? _elderlyLocation;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchElders();
  }

  Future<void> _fetchElders() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String familyCode = userSnapshot['familyCode'];

      DocumentSnapshot familySnapshot = await FirebaseFirestore.instance
          .collection('family')
          .doc(familyCode)
          .get();

      List<String> memberIds = [];
      Map<String, dynamic>? familyData = familySnapshot.data() as Map<String, dynamic>?;

      if (familyData != null) {
        familyData.forEach((key, value) {
          if (key.startsWith('member') && value is String) {
            memberIds.add(value);
          }
        });
      }

      List<String> elders = [];
      for (String memberId in memberIds) {
        DocumentSnapshot memberSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .get();
        if (memberSnapshot['role'] == 'elder') {
          elders.add(memberSnapshot['username']);
        }
      }

      setState(() {
        _elderlyList = elders;
      });
    } catch (e) {
      print('Error fetching elders: $e');
    }
  }

  Future<void> _fetchElderLocation(String elderName) async {
    try {
      DocumentSnapshot elderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: elderName)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      List<dynamic> location = elderSnapshot['location'];
      LatLng latLng = LatLng(location[0], location[1]);

      setState(() {
        _elderlyLocation = latLng;
        _markers = {
          Marker(
            markerId: MarkerId(elderName),
            position: latLng,
            infoWindow: InfoWindow(title: elderName),
          ),
        };
      });
    } catch (e) {
      print('Error fetching elder location: $e');
      setState(() {
        _elderlyLocation = null;
        _markers = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Elderly',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color:Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor:Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Map Placeholder Card or Google Map
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 200,
                child: _elderlyLocation != null
                    ? GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: _elderlyLocation!,
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: _markers,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map,
                                  size: 50, color: AppColors.titleGreen),
                              const SizedBox(height: 10),
                              Text(
                                'Google Map will appear here',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Elderly to Find",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedElderly,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      ),
                      hint: const Text("Choose an elderly"),
                      items: _elderlyList.map((elderly) {
                        return DropdownMenuItem(
                          value: elderly,
                          child: Text(elderly),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedElderly = value;
                          _fetchElderLocation(value!);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.titleGreen,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Status:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedElderly != null
                                ? "Finding ${_selectedElderly}"
                                : "No elderly selected",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedElderly != null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Finding ${_selectedElderly}..."),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.titleGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Find',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}