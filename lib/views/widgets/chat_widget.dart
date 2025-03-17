import 'package:flutter/material.dart';

class AIMessageWidget extends StatelessWidget {
  const AIMessageWidget({super.key, required this.response});
  final String response;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(radius: 40.0),
        SizedBox(width: 10.0),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250.0,
            minHeight: 20.0,
            minWidth: 20.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(response, style: TextStyle(fontSize: 20.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class userMessageWidget extends StatelessWidget {
  const userMessageWidget({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 250.0,
            minHeight: 20.0,
            minWidth: 20.0,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(message, style: TextStyle(fontSize: 20.0)),
            ),
          ),
        ),
        SizedBox(width: 10.0),
        CircleAvatar(radius: 40.0),
      ],
    );
  }
}
