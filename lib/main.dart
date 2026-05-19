import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('抽卡版')),
        body: Center(child: Text('Hello world')),
        backgroundColor: Colors.blueGrey.shade100,
      ),
    );
  }
}
