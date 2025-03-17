import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/chat_widget.dart';

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

  void updateChat(String user_text, String AI_text) {
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
      messages.add(AIMessageWidget(response: AI_text, isLoading: true));
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
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    updateChat(
                      userInputController.text,
                      'This is a dummy response', //TODO: replace with actual response
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
