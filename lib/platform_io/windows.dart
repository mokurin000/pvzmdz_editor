library;

import 'dart:io' as io;

import 'package:logger/logger.dart';
import 'package:win32/win32.dart';

import 'package:pvzmdz_editor/platform_io/base.dart';

final Logger logger = Logger(filter: DevelopmentFilter());

String _getGameBaseDir() {
  const String folderId = '{A520A1A4-1780-4FF6-BD18-167343C5AF16}';
  final GUID guid = GUID(folderId);

  final PWSTR path = SHGetKnownFolderPath(
    guid.toNative(),
    KF_FLAG_DEFAULT,
    null,
  );

  return "${path.toDartString()}/MiaoDouzi/抽卡版PVZ";
}

final String gameDataDir = _getGameBaseDir();
final String gameDataPath = "$gameDataDir/save.json";
final String gameMD5Path = "$gameDataDir/save.json.md5";

class WindowsPlatform extends IOApi {
  WindowsPlatform();

  @override
  Future<String?> readGameSaveData() async {
    try {
      final String gameData = await io.File(gameDataPath).readAsString();
      return gameData;
    } on io.PathAccessException {
      logger.e("Access denied: $gameDataPath");
      return null;
    } on io.PathNotFoundException {
      logger.w("SaveData not existing: $gameDataPath");
      return null;
    } on io.FileSystemException catch (e) {
      logger.e('IO error: ${e.message}');
      logger.e('Path: ${e.path}');
      logger.e('OS error: ${e.osError}');
    }

    return null;
  }

  @override
  Future<void> writeGameSaveData(String gameData) async {
    await io.File(gameDataPath).writeAsString(gameData);
    try {
      await io.File(gameMD5Path).delete();
    } on io.PathNotFoundException {}
  }
}
