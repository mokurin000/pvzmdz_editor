## 通用 Agent 工作原则

1. 始终 遵守上述文件读取规则。
2. 所有 Dart 代码必须符合 Effective Dart idiomatic 风格。
3. 生成代码前先思考项目上下文和现有代码风格。
4. 优先提供清晰、可维护、符合语言习惯的实现。
5. 如需修改现有文件，必须 先正确读取文件内容（使用 bash）。
6. 禁止将实现细节、设计准则、显而易见的使用说明等作为 UI 实体加入，这些属于内部细节。

如有疑问，请先确认环境工具使用方式。

### rg 使用规范

调用 rg 时，为避免 " 转义问题，总是直接调用 rg.exe 。

bad:

```bash
C:\\Windows\\system32\\cmd.exe" /c "bash.exe -lc 'rg -n "SaveEditorScreen|Animated|LayoutBuilder|MediaQuery|panel|DesktopSaveEditorPage|MobileSaveEditorPage" lib/save_editor.dart
```

good:

```bash
rg.exe -n "SaveEditorScreen|Animated|LayoutBuilder|MediaQuery|panel|DesktopSaveEditorPage|MobileSaveEditorPage" lib/save_editor.dart
```

### Win32 Path

Windows 路径同时支持 `/` 和 `\` ，但 `\\` 更容易引起问题。

### Bash calling

* NEVER use bash to call powershell commands like write-output.

good:

```bash
# read `lib/main.dart`
bash.exe -c "cat 'lib/main.dart'"

# read `lib/main.dart`, L10~L20
bash.exe -c "sed -n '10,20p' lib/main.dart"
```

bad:

```bash
C:/Windows/system32/cmd.exe /c "bash.exe -lc '...'"
```

### 文件读取要求

严禁 使用 PowerShell 的 Get-Content 命令读取任何文件。

原因：PowerShell 默认编码处理存在问题，无法可靠地正确读取 UTF-8 文件（尤其是包含中文或其他非 ASCII 字符的文件），容易导致乱码或数据损坏。

正确做法：
- 优先使用 Git Bash（bash.exe）运行命令。
- 或者使用 cmd.exe 执行命令。
- 示例（推荐）：

```bash
# 使用 bash
bash.exe -c "cat file.md"

# 使用 cmd
cmd.exe /c "type file.md"
```

环境已预装 Git Bash，请优先通过 bash.exe 执行 shell 命令，确保编码正确。

## Dart 代码风格规范

本项目遵循 Effective Dart 官方指南。以下为重点 idiomatic 用法摘要，所有生成的 Dart/Flutter 代码必须严格遵守。

### 1. 命名规范（Naming）
- 文件命名：使用 snake_case（小写 + 下划线），如 user_profile.dart。
- 类、类型、扩展：UpperCamelCase（PascalCase）。
- 变量、函数、参数、方法：lowerCamelCase。
- 常量（const）：lowerCamelCase（推荐，符合 Dart idiomatic）。
- 枚举值：lowerCamelCase。

```dart
// Good
class UserProfile {
  const UserProfile(this.name);

  final String name;
}

const defaultTimeout = Duration(seconds: 30);
```

### 2. 导入规范（Directives）
- 按以下顺序组织导入：
  1. Dart SDK
  2. 第三方包
  3. 本地相对导入（../ 或 ./）

- 使用 show / hide 减少命名冲突。
- 避免不必要的导入。

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'widgets/profile_avatar.dart';
```

### 3. 字符串与插值
- 优先使用字符串插值（$var 或 ${expression}），而非拼接。
- 多行字符串使用 ''' 或 """。

```dart
// Good
final message = 'Hello, $name! You have ${notifications.length} new messages.';
```

### 4. 集合与函数式编程
- 优先使用 map、where、forEach、reduce 等函数式方法。
- 避免显式 for 循环（除非性能关键或需要 break/continue）。

```dart
final activeUsers = users.where((u) => u.isActive).toList();
final names = users.map((u) => u.name).join(', ');
```

### 5. 空安全（Null Safety）最佳实践
- 优先使用 non-nullable 类型。
- 使用 late、required、??、?.、! 时必须谨慎且有充分理由。
- 推荐使用本地变量提取避免重复 ! 断言。

```dart
// Good
String? maybeName = user.name;
if (maybeName case final name?) {
  print('Hello $name');
}
```

### 6. 其他 idiomatic 建议
- 避免 print()，使用 package:logger 提供的 logger, DevelopmentFilter。
- 优先 使用 const 构造函数和常量。
- getter 用于无副作用的计算属性。
- 避免 过长的函数（建议单个函数不超过 30-40 行）。
- 使用 extension 方法增强现有类型。
- 错误处理优先使用 Either / Result 类型或明确的异常（视项目而定）。
