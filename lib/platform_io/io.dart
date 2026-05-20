/// Game Savedata & Checksum read/write
library;

import 'dart:io' as io;

import 'package:pvzmdz_editor/platform_io/base.dart';
import 'package:pvzmdz_editor/platform_io/windows.dart';

IOApi? getPlatformApi() {
  if (io.Platform.isWindows) {
    return WindowsPlatform();
  }
  return null;
}

final IOApi? platformApi = getPlatformApi();

Future<String?> readGameSaveData() async {
  return await platformApi?.readGameSaveData();
}

Future<void> writeGameSaveData(String gameData) async {
  await platformApi?.writeGameSaveData(gameData);
}
