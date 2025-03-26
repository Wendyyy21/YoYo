import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/views/widgets/wordle_widget.dart';

class Elderly_GamePage extends StatefulWidget {
  const Elderly_GamePage({super.key});

  @override
  State<Elderly_GamePage> createState() => _Elderly_GamePageState();
}

class _Elderly_GamePageState extends State<Elderly_GamePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'WORDLE',
                    style: TextStyle(
                      fontFamily: 'WinkySans',
                      fontSize: 50.0,
                      letterSpacing: 10.0,
                      color: AppColors.titleGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  WordleWidget(),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
            Positioned(
              right: 0.5,
              top: 0.5,
              child: FloatingActionButton(
                onPressed: () => displayHint(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Icon(Icons.question_mark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void displayHint() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            height: 400.0,
            width: 300.0,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                      Text(
                        'How to play?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '1. You have six attempts to correctly guess a five-letter word. \n2. The colour of the tiles indicate the accuracy of each guess: \n- Green: Correct letter, and in the correct position \n- Yellow: Correct letter, but in the wrong position \n- Grey: Wrong letter',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
