import 'package:flutter/material.dart';

class Young_MapPage extends StatefulWidget {
  const Young_MapPage({super.key});

  @override
  State<Young_MapPage> createState() => _Young_mapState();
}

class _Young_mapState extends State<Young_MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Elderly'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Google Map Placeholder',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Elderly Location: Unknown',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}