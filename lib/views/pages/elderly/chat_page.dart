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
  ScrollController scrollController = ScrollController();
  List<Widget> messages = [
    SizedBox(height: 10.0),
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
      messages.add(SizedBox(height: 10.0));
      messages.add(userMessageWidget(message: user_text));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    setState(() {
      messages.add(SizedBox(height: 10.0));
      messages.add(AIMessageWidget(response: '', isLoading: true)); //show loading indicator
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      _chat.add(Content('user', [TextPart(user_text)])); // User message, added to list
      final response = await _model.generateContent(_chat); // Pass the list
      final text = response.text;
      if (text != null) {
        setState(() {
          messages.removeLast(); //remove loading indicator
          messages.add(AIMessageWidget(response: text, isLoading: false));
        });
        _chat.add(Content('model', [TextPart(text)])); // AI message, added to list
      } else {
        setState(() {
          messages.removeLast(); //remove loading indicator
          messages.add(AIMessageWidget(response: "Error: Could not get a response", isLoading: false));
        });
      }
    } catch (e) {
      setState(() {
        messages.removeLast(); //remove loading indicator
        messages.add(AIMessageWidget(response: "Error: $e", isLoading: false));
      });
    }
  }

  @override
  void dispose() {
    userInputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: messages,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 243, 243),
            border: Border(
              top: BorderSide(
                color: const Color.fromARGB(255, 222, 220, 220),
                width: 1.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: userInputController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 253, 252, 252),
                      filled: true,
                      hintText: 'Type anything',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted:  (value) {
                      updateChat(
                      userInputController.text,
                      '');

                      userInputController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    await updateChat(
                      userInputController.text,
                      '', //removed dummy reply
                    );
                    userInputController.clear();
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}