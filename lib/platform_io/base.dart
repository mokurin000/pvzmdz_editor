abstract class IOApi {
  Future<String?> readGameSaveData();

  /// write back Game savedata.
  ///
  /// The MD5 file must be deleted, to against anti-cheat check.
  Future<void> writeGameSaveData(String gameData);
}
