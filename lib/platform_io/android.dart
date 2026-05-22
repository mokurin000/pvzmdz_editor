library;

import 'dart:io' as io;

import 'package:logger/logger.dart';
import 'package:shizuku_api/shizuku_api.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pvzmdz_editor/platform_io/base.dart';

final Logger logger = Logger(filter: DevelopmentFilter());
final ShizukuApi _shizukuApi = ShizukuApi();

const String _gameSaveSourceDir =
    '/storage/self/primary/Android/data/com.MiaoDouzi.PVZ/files';
const String _gameSaveSourcePath = '$_gameSaveSourceDir/save.json';
const String _gameSaveSourceMd5Path = '$_gameSaveSourceDir/save.json.md5';
const String _gameSaveLocalDir =
    '/storage/self/primary/Android/data/io.github.mokurin000.pvzmdz_editor/files';
const String _gameSaveLocalPath = '$_gameSaveLocalDir/save.json';

class ShizukuBinderNotRunningException implements Exception {
  const ShizukuBinderNotRunningException();

  @override
  String toString() => 'Shizuku 未运行。';
}

class ShizukuPermissionDeniedException implements Exception {
  const ShizukuPermissionDeniedException();

  @override
  String toString() => 'Shizuku 权限未授予。';
}

class ShizukuCommandFailedException implements Exception {
  const ShizukuCommandFailedException(this.command);

  final String command;

  @override
  String toString() => 'Shizuku 命令执行失败：$command';
}

Future<void> _ensureShizukuReady() async {
  final isBinderRunning = await _shizukuApi.pingBinder() ?? false;
  if (!isBinderRunning) {
    throw const ShizukuBinderNotRunningException();
  }

  final hasPermission = await _shizukuApi.checkPermission() ?? false;
  if (!hasPermission) {
    throw const ShizukuPermissionDeniedException();
  }
}

Future<void> _runCommandChecked(String command) async {
  logger.i("Run Command: $command");

  final result = await _shizukuApi.runCommand(command);
  if (result == null) {
    throw ShizukuCommandFailedException(command);
  }
}

Future<String?> readGameSaveDataImpl() async {
  // ensure Android creates `data/${applicaionId}/files`
  await getExternalStorageDirectory();

  try {
    await _ensureShizukuReady();
    await _runCommandChecked("cp -f $_gameSaveSourcePath $_gameSaveLocalPath");

    final localSaveFile = io.File(_gameSaveLocalPath);
    if (!await localSaveFile.exists()) {
      logger.w('Save file not found at $_gameSaveLocalPath');
      return null;
    }

    return localSaveFile.readAsString();
  } on ShizukuCommandFailedException catch (error, stackTrace) {
    logger.w(
      'Failed to read save data through Shizuku.',
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  } on io.FileSystemException catch (error, stackTrace) {
    logger.e(
      'Failed to read save data from local cache.',
      error: error,
      stackTrace: stackTrace,
    );
    return null;
  }
}

Future<void> writeGameSaveDataImpl(String gameData) async {
  await _ensureShizukuReady();
  await io.File(_gameSaveLocalPath).writeAsString(gameData, flush: true);
  await _runCommandChecked(
    "mv -f $_gameSaveLocalPath $_gameSaveSourcePath; rm -f $_gameSaveSourceMd5Path",
  );
}

class AndroidPlatform extends IOApi {
  AndroidPlatform();

  @override
  Future<String?> readGameSaveData() {
    return readGameSaveDataImpl();
  }

  @override
  Future<void> writeGameSaveData(String gameData) {
    return writeGameSaveDataImpl(gameData);
  }
}
