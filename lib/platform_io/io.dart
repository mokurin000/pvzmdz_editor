/// Game Savedata & Checksum read/write
library;

import 'dart:io' as io;

import 'package:pvzmdz_editor/platform_io/android.dart';
import 'package:pvzmdz_editor/platform_io/base.dart';
import 'package:pvzmdz_editor/platform_io/windows.dart';

IOApi? getPlatformApi() {
  if (io.Platform.isAndroid) {
    return AndroidPlatform();
  }
  if (io.Platform.isWindows) {
    return WindowsPlatform();
  }
  return null;
}

final IOApi? platformApi = getPlatformApi();

Future<String?> readGameSaveData() async {
  final api = platformApi;
  if (api == null) {
    throw UnsupportedError('Unsupported platform for save data access.');
  }

  return api.readGameSaveData();
}

Future<void> writeGameSaveData(String gameData) async {
  final api = platformApi;
  if (api == null) {
    throw UnsupportedError('Unsupported platform for save data access.');
  }

  await api.writeGameSaveData(gameData);
}
