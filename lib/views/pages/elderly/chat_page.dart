import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/chat_widget.dart';

class Elderly_ChatPage extends StatefulWidget {
  const Elderly_ChatPage({super.key});

  @override
  State<Elderly_ChatPage> createState() => _Elderly_ChatPageState();
}

class _Elderly_ChatPageState extends State<Elderly_ChatPage> {
  TextEditingController userInputController = TextEditingController();
  List<Widget> messages = [
    AIMessageWidget(
      response: 'Hi, I\'m YoYo! Type in the text box below to start chatting!',
    ),
  ];

  void updateChat(String user_text, String AI_text) {
    setState(() {
      messages.add(userMessageWidget(message: user_text));
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        messages.add(AIMessageWidget(response: AI_text));
      });
    });
  }

  @override
  void dispose() {
    userInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: messages,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: userInputController,
                  decoration: const InputDecoration(
                    hintText: 'Type anything',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  updateChat(
                    userInputController.text,
                    'This is a dummy response',
                  );
                  userInputController.clear();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
