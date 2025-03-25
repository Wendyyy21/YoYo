import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:lottie/lottie.dart';

class Young_HomePage extends StatelessWidget {
  const Young_HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                const Card(
                  color: Color.fromARGB(255, 247, 240, 168),
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Continue chatting',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Icon(Icons.group, size: 50.0),
                            SizedBox(width: 20.0),
                            Text(
                              'Community',
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
                            'Medication reminder',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Icon(Icons.create, size: 50.0),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create New',
                                  style: TextStyle(
                                    fontSize: 30.0),
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
      ),
    );
  }
}
