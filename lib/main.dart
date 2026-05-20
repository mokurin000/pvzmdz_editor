import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:pvzmdz_editor/platform_io/io.dart';

final logfilter = DevelopmentFilter();

void main() {
  runApp(const MainApp());
}

Future<void> readSaveData() async {
  logfilter.level = Level.info;
  final logger = Logger(filter: logfilter);

  String? gameData = await readGameSaveData();
  logger.i(gameData);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    readSaveData();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('抽卡版存档修改器')),
        body: Center(child: Text('Hello world')),
        backgroundColor: Colors.blueGrey.shade100,
      ),
    );
  }
}
