import 'package:flutter/material.dart';

class Elderly_WordSearchPage extends StatefulWidget {
  const Elderly_WordSearchPage({super.key});

  @override
  State<Elderly_WordSearchPage> createState() => _Elderly_WordSearchPageState();
}

class _Elderly_WordSearchPageState extends State<Elderly_WordSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Center(child: Text('word search')));
  }
}
