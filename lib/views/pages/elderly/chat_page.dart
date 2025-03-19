import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/chat_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

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
      isLoading: false,
    ),
  ];

  late GenerativeModel _model;
  List<Content> _chat = []; // Changed to List<Content>

  @override
  void initState() {
    super.initState();
    String apiKey = '';
    if (kIsWeb) {
      // Web: Get API key from compile-time variable.
      const tempApiKey = String.fromEnvironment('GEMINI_API_KEY');
      apiKey = tempApiKey;
    } else {
      // Native: Get API key from .env file.
      // apiKey = dotenv.env['GEMINI_API_KEY']!;
      apiKey = "AIzaSyAt5yB4uvBXTOButT2qQiiR0d8R87Nn4QA";
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash', // Correct model name
      apiKey: apiKey
    );
    _chat.add(Content('user', [ // Use add to add to list
      TextPart('You are a helpful assistant for elderly people.'),
      TextPart('Your name is YoYo. Please keep the conversation light and friendly.'),
      TextPart('You can help elderly people with their daily tasks and provide companionship.'),
      TextPart('You can also provide information on various topics and answer questions.'),
      TextPart('But keep the responses short (a paragraph), unless otherwise requested.'),
    ]));
  }

  Future<void> updateChat(String user_text, String AI_text) async {
    setState(() {
      messages.add(userMessageWidget(message: user_text));
    });
    setState(() {
      messages.add(AIMessageWidget(response: AI_text, isLoading: true));
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
