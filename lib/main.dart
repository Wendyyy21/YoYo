// main.dart
import 'package:flutter/material.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Web: Use compile-time variables (passed via --dart-define).
    // Example:
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    print('Web API Key: $apiKey');
    // Important: Pass API_KEY when running:
    // flutter run -d chrome --dart-define=API_KEY="YOUR_API_KEY"
  } else {
    // Native: Load .env file using flutter_dotenv.
    // await dotenv.load(fileName: "/Users/jordan/Desktop/Live_Projects/KitaHack 2025/YoYo/.env");
    // print('Native API Key: ${dotenv.env['GEMINI_API_KEY']}');
  }

  // Initialize Firebase (common for both web and native).
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: WelcomePage(),
    );
  }
}