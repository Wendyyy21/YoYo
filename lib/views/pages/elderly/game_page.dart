import 'package:flutter/material.dart';
import 'package:frontend/views/pages/elderly/wordsearch_page.dart';

class Elderly_GamePage extends StatelessWidget {
  const Elderly_GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/word_search_bg.png'),
                Text(
                  'WORD SEARCH',
                  style: TextStyle(
                    fontSize: 50.0,
                    color: const Color.fromARGB(255, 17, 118, 201),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Look for a given list of words in the grid. \nTap the button below to play.',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Elderly_WordSearchPage();
                    },
                  ),
                );
              },
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
