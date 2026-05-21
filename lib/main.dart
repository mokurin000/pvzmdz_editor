import 'package:flutter/material.dart';

import 'package:pvzmdz_editor/save_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '抽卡版存档修改器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Microsoft YaHei UI',
        useMaterial3: true,

        appBarTheme: const AppBarTheme(centerTitle: true),

        // 可选：同时设置其他文本样式
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: const SaveEditorScreen(),
    );
  }
}
