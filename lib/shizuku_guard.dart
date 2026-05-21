import 'package:flutter/material.dart';
import 'package:shizuku_api/shizuku_api.dart';

import 'package:pvzmdz_editor/platform_io/android.dart';
import 'package:pvzmdz_editor/save_editor.dart';

class ShizukuGuardPage extends StatefulWidget {
  const ShizukuGuardPage({super.key});

  @override
  State<ShizukuGuardPage> createState() => _ShizukuGuardPageState();
}

class _ShizukuGuardPageState extends State<ShizukuGuardPage> {
  final ShizukuApi _shizukuApi = ShizukuApi();
  bool _isChecking = true;
  String? _errorMessage;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkShizuku();
  }

  Future<void> _checkShizuku() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final isBinderRunning = await _shizukuApi.pingBinder() ?? false;
      if (!isBinderRunning) {
        throw const ShizukuBinderNotRunningException();
      }

      final hasPermission = await _shizukuApi.checkPermission() ?? false;
      if (!hasPermission) {
        final requestPermission =
            await _shizukuApi.requestPermission() ?? false;
        if (!requestPermission) {
          throw const ShizukuPermissionDeniedException();
        }
      }

      if (!mounted || _hasNavigated) {
        return;
      }

      _hasNavigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const SaveEditorScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isChecking = false;
        _errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _errorMessage ??
        '正在检查 Shizuku 状态和权限，请稍候。';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shizuku 检查'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Shizuku 访问准备',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_isChecking)
                      const Center(child: CircularProgressIndicator())
                    else
                      FilledButton(
                        onPressed: _checkShizuku,
                        child: const Text('重试'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
