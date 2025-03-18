import 'package:flutter/material.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async { //.env file stuff
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
