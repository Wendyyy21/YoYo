import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/elderly/game_page.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Elderly_HomePage extends StatefulWidget {
  const Elderly_HomePage({super.key});

  @override
  State<Elderly_HomePage> createState() => _Elderly_HomePageState();
}

class _Elderly_HomePageState extends State<Elderly_HomePage> {
  @override
  void initState() {
    super.initState();
    _configureBackgroundLocation();
  }

  Future<void> _configureBackgroundLocation() async {
    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      forceReloadOnLocationChange: true,
      forceReloadOnMotionChange: true,
      forceReloadOnGeofence: false,
      stopTimeout: 1,
      locationAuthorizationAlert: {
        'titleWhenNotEnabled': "Location services are not enabled",
        'instructions': "You must enable 'Always' in location services",
        'cancelButton': "Cancel",
        'settingsButton': "Settings"
      }
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      _saveLocationToFirestore(location);
    });

    bg.BackgroundGeolocation.requestPermission();
  }

  Future<void> _saveLocationToFirestore(bg.Location location) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'location': [location.coords.latitude, location.coords.longitude],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Location saved to Firestore for user: ${user.uid}');
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Lottie.asset('assets/lotties/yoyo_model.json', height: 300.0),
              const SizedBox(height: 20.0),
              const Text(
                "Hello, I'm YoYo!",
                style: TextStyle(
                  fontFamily: 'Kalam',
                  fontSize: 30.0,
                  color: AppColors.titleGreen,
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  selectedPageNotifier.value = 2;
                },
                child: const Card(
                  color: Color.fromARGB(255, 247, 240, 168),
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Continue playing',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/images/wordle_logo.png',
                              ),
                              height: 120.0,
                            ),
                            SizedBox(width: 20.0),
                            Text(
                              'Wordle',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Card(
                elevation: 10.0,
                color: Color.fromARGB(255, 250, 246, 193),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Next medication reminder',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 50.0),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today 7pm',
                                style: TextStyle(fontSize: 30.0),
                              ),
                              Text(
                                'Calcium - 1 tablet',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'Vitamin B12 - 1 tablet',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}