import 'dart:convert';
import 'dart:io';

import 'package:pvzmdz_editor/src/game_data.dart';

Future<void> main() async {
  const inputPath =
      r'C:\Users\moku\AppData\LocalLow\MiaoDouzi\抽卡版PVZ\save.json';

  const outputPath =
      r'C:\Users\moku\AppData\LocalLow\MiaoDouzi\抽卡版PVZ\save1.json';

  try {
    // 读取 JSON 文件
    final jsonString = await File(inputPath).readAsString();

    // 解析 JSON
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    // 反序列化
    final gameData = GameData.fromJson(jsonMap);

    // 再序列化
    final encoded = const JsonEncoder.withIndent(
      '  ',
    ).convert(gameData.toJson());

    // 写入新文件
    await File(outputPath).writeAsString(encoded);

    print('转换完成');
    print('输入: $inputPath');
    print('输出: $outputPath');
  } catch (e, stackTrace) {
    print('处理失败: $e');
    print(stackTrace);
  }
}
