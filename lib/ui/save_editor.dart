import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:pvzmdz_editor/game_data.dart';
import 'package:pvzmdz_editor/platform_io/io.dart';
import 'package:pvzmdz_editor/ui/pages/desktop.dart';
import 'package:pvzmdz_editor/ui/pages/mobile.dart';
import 'package:pvzmdz_editor/widgets/sun_initial.dart';

final logger = Logger(filter: DevelopmentFilter());

class SaveEditorScreen extends StatefulWidget {
  const SaveEditorScreen({super.key});

  @override
  State<SaveEditorScreen> createState() => _SaveEditorScreenState();
}

class _SaveEditorScreenState extends State<SaveEditorScreen> {
  static final _minScreenWidth = io.Platform.isAndroid ? 0.0 : 400.0;
  static const _minScreenHeight = 500.0;
  static const _panelSwitchDuration = Duration(milliseconds: 300);

  final _formKey = GlobalKey<FormState>();
  final _chushisunCtrl = TextEditingController();
  final _coinCtrl = TextEditingController();
  final _maoliangCtrl = TextEditingController();
  final _touziCtrl = TextEditingController();
  final _touzi2Ctrl = TextEditingController();
  final _coinYingtaoCtrl = TextEditingController();
  final _sunPokeCtrl = TextEditingController();
  final _zmPokeCtrl = TextEditingController();
  final _tianjiangCtrl = TextEditingController();
  final _maoxianCtrl = TextEditingController();
  final _maoxianIfaCtrl = TextEditingController();
  final _maoxianSnowCtrl = TextEditingController();
  final _wujincengCtrl = TextEditingController();
  final _wujinceng2Ctrl = TextEditingController();
  final _wujinceng2LastCtrl = TextEditingController();
  final _wujinceng3Ctrl = TextEditingController();

  GameData? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final rawData = await readGameSaveData();
      final data = rawData != null
          ? GameData.fromJson(jsonDecode(rawData))
          : GameData.defaultData();

      if (!mounted) {
        return;
      }

      setState(() {
        _data = data;
        _isLoading = false;
      });
      _syncControllers(data);
    } catch (error, stackTrace) {
      logger.e(
        'Failed to load save data.',
        error: error,
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      final fallbackData = GameData.defaultData();
      setState(() {
        _data = fallbackData;
        _isLoading = false;
      });
      _syncControllers(fallbackData);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '读取存档失败：$error',
              style: const TextStyle(
                fontFamily: "Microsoft YaHei UI",
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _syncControllers(GameData data) {
    _chushisunCtrl.text = data.chushisun.toString();
    _coinCtrl.text = data.coin.toString();
    _maoliangCtrl.text = data.maoliang.toString();
    _touziCtrl.text = data.touzi.toString();
    _touzi2Ctrl.text = data.touzi2.toString();
    _coinYingtaoCtrl.text = data.coinYingtao.toString();
    _sunPokeCtrl.text = data.sunPokeCishu.toString();
    _zmPokeCtrl.text = data.zmPokeCishu.toString();
    _tianjiangCtrl.text = data.tianjianglihe.toString();
    _maoxianCtrl.text = data.Maoxian.toString();
    _maoxianIfaCtrl.text = data.MaoxianIFA.toString();
    _maoxianSnowCtrl.text = data.MaoxianSnow.toString();
    _wujincengCtrl.text = data.wujinceng.toString();
    _wujinceng2Ctrl.text = data.wujinceng2.toString();
    _wujinceng2LastCtrl.text = data.wujinceng2Last.toString();
    _wujinceng3Ctrl.text = data.wujinceng3.toString();
  }

  int get initialSunlight => 50 + 25 * (_data?.chushisun ?? 0);

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentData = _data;
    if (currentData == null) {
      return;
    }

    final newData = currentData.copyWith(
      chushisun: int.tryParse(_chushisunCtrl.text) ?? 0,
      coin: int.tryParse(_coinCtrl.text) ?? 0,
      maoliang: int.tryParse(_maoliangCtrl.text) ?? 0,
      touzi: int.tryParse(_touziCtrl.text) ?? 0,
      touzi2: int.tryParse(_touzi2Ctrl.text) ?? 0,
      coinYingtao: int.tryParse(_coinYingtaoCtrl.text) ?? 0,
      sunPokeCishu: int.tryParse(_sunPokeCtrl.text) ?? 0,
      zmPokeCishu: int.tryParse(_zmPokeCtrl.text) ?? 0,
      tianjianglihe: int.tryParse(_tianjiangCtrl.text) ?? 0,
      Maoxian: int.tryParse(_maoxianCtrl.text) ?? 0,
      MaoxianIFA: int.tryParse(_maoxianIfaCtrl.text) ?? 0,
      MaoxianSnow: int.tryParse(_maoxianSnowCtrl.text) ?? 0,
      wujinceng: int.tryParse(_wujincengCtrl.text) ?? 0,
      wujinceng2: int.tryParse(_wujinceng2Ctrl.text) ?? 0,
      wujinceng2Last: int.tryParse(_wujinceng2LastCtrl.text) ?? 0,
      wujinceng3: int.tryParse(_wujinceng3Ctrl.text) ?? 0,
      chuizhitongbu: false,
    );

    try {
      await writeGameSaveData(jsonEncode(newData.toJson()));
      if (!mounted) {
        return;
      }

      setState(() => _data = newData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '存档修改成功！',
            style: TextStyle(
              fontFamily: "Microsoft YaHei UI",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error, stackTrace) {
      logger.e('Failed to save data.', error: error, stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '保存失败：$error',
            style: const TextStyle(
              fontFamily: "Microsoft YaHei UI",
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _unlockAllPlants() {
    final currentData = _data;
    if (currentData == null) {
      return;
    }

    setState(() {
      _data = currentData.copyWith(
        scores: allPlantScores,
        // Already have it
        canbaohusan: true,
        // No longer needed
        liekabao: true,
        xykabao: true,
        sskabao: true,
        ptkabao: true,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '已解锁全部植物',
          style: TextStyle(
            fontFamily: "Microsoft YaHei UI",
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  @override
  void dispose() {
    _chushisunCtrl.dispose();
    _coinCtrl.dispose();
    _maoliangCtrl.dispose();
    _touziCtrl.dispose();
    _touzi2Ctrl.dispose();
    _coinYingtaoCtrl.dispose();
    _sunPokeCtrl.dispose();
    _zmPokeCtrl.dispose();
    _tianjiangCtrl.dispose();
    _maoxianCtrl.dispose();
    _maoxianIfaCtrl.dispose();
    _maoxianSnowCtrl.dispose();
    _wujincengCtrl.dispose();
    _wujinceng2Ctrl.dispose();
    _wujinceng2LastCtrl.dispose();
    _wujinceng3Ctrl.dispose();
    super.dispose();
  }

  Widget _buildChushisunCard() {
    return ChushisunCard(
      controller: _chushisunCtrl,
      initialSunlight: initialSunlight,
      onChanged: (sun) {
        final currentData = _data;
        if (currentData == null) {
          return;
        }

        setState(() {
          _data = currentData.copyWith(chushisun: int.tryParse(sun) ?? 0);
        });
      },
    );
  }

  Widget _buildEditorPage({required bool isDesktop}) {
    final pageKey = ValueKey(isDesktop ? 'desktop-editor' : 'mobile-editor');
    final chushisunCard = _buildChushisunCard();

    if (isDesktop) {
      return KeyedSubtree(
        key: pageKey,
        child: DesktopSaveEditorPage(
          chushisunCard: chushisunCard,
          coinController: _coinCtrl,
          maoliangController: _maoliangCtrl,
          touziController: _touziCtrl,
          touzi2Controller: _touzi2Ctrl,
          coinYingtaoController: _coinYingtaoCtrl,
          sunPokeController: _sunPokeCtrl,
          zmPokeController: _zmPokeCtrl,
          tianjiangController: _tianjiangCtrl,
          maoxianController: _maoxianCtrl,
          maoxianIfaController: _maoxianIfaCtrl,
          maoxianSnowController: _maoxianSnowCtrl,
          wujincengController: _wujincengCtrl,
          wujinceng2Controller: _wujinceng2Ctrl,
          wujinceng2LastController: _wujinceng2LastCtrl,
          wujinceng3Controller: _wujinceng3Ctrl,
          onUnlockAllPlants: _unlockAllPlants,
          onSave: _saveData,
        ),
      );
    }

    return KeyedSubtree(
      key: pageKey,
      child: MobileSaveEditorPage(
        chushisunCard: chushisunCard,
        coinController: _coinCtrl,
        maoliangController: _maoliangCtrl,
        touziController: _touziCtrl,
        touzi2Controller: _touzi2Ctrl,
        coinYingtaoController: _coinYingtaoCtrl,
        sunPokeController: _sunPokeCtrl,
        zmPokeController: _zmPokeCtrl,
        tianjiangController: _tianjiangCtrl,
        maoxianController: _maoxianCtrl,
        maoxianIfaController: _maoxianIfaCtrl,
        maoxianSnowController: _maoxianSnowCtrl,
        wujincengController: _wujincengCtrl,
        wujinceng2Controller: _wujinceng2Ctrl,
        wujinceng2LastController: _wujinceng2LastCtrl,
        wujinceng3Controller: _wujinceng3Ctrl,
        onUnlockAllPlants: _unlockAllPlants,
        onSave: _saveData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: null),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: null),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
          fontFamily: null,
        ),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('抽卡版存档修改器'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.maxWidth < _minScreenWidth
                ? _minScreenWidth
                : constraints.maxWidth;
            final viewportHeight = constraints.maxHeight < _minScreenHeight
                ? _minScreenHeight
                : constraints.maxHeight;

            if (_isLoading) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: viewportWidth,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: _minScreenWidth,
                        minHeight: viewportHeight,
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              );
            }

            // DON'T TOUCH, UI trick
            final isDesktop =
                constraints.maxWidth / 1.5 > constraints.maxHeight;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: viewportWidth,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _minScreenWidth,
                      minHeight: viewportHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      child: AnimatedSize(
                        duration: _panelSwitchDuration,
                        curve: Curves.easeInOutCubic,
                        child: AnimatedSwitcher(
                          duration: _panelSwitchDuration,
                          switchInCurve: Curves.easeInOutBack,
                          switchOutCurve: Curves.easeInOutBack,
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(0.06, 0),
                              end: Offset.zero,
                            ).animate(animation);

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: _buildEditorPage(isDesktop: isDesktop),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
