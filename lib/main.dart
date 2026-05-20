import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:pvzmdz_editor/platform_io/io.dart';
import 'package:pvzmdz_editor/src/game_data.dart';

final logfilter = DevelopmentFilter();
final logger = Logger(filter: logfilter);

void main() {
  runApp(const MainApp());
}

Future<void> operateSaveData() async {
  logfilter.level = Level.info;

  String? gameData = await readGameSaveData();

  final GameData gameDataModel;
  if (gameData != null) {
    gameDataModel = GameData.fromJson(jsonDecode(gameData));
  } else {
    gameDataModel = GameData.defaultData();
  }

  logger.i(gameDataModel.chuizhitongbu);
  final GameData noAntiCheat = gameDataModel.copyWith(chuizhitongbu: false);
  logger.i(noAntiCheat.chuizhitongbu);

  await writeGameSaveData(jsonEncode(noAntiCheat.toJson()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    operateSaveData();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('抽卡版存档修改器')),
        body: Center(child: Text('Hello world')),
        backgroundColor: Colors.blueGrey.shade100,
      ),
    );
  }
}
