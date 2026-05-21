import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:pvzmdz_editor/game_data.dart';
import 'package:pvzmdz_editor/platform_io/io.dart';

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
  final _touziCtrl = TextEditingController();
  final _touzi2Ctrl = TextEditingController();
  final _coinYingtaoCtrl = TextEditingController();
  final _sunPokeCtrl = TextEditingController();
  final _zmPokeCtrl = TextEditingController();
  final _tianjiangCtrl = TextEditingController();

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
    _touziCtrl.text = data.touzi.toString();
    _touzi2Ctrl.text = data.touzi2.toString();
    _coinYingtaoCtrl.text = data.coinYingtao.toString();
    _sunPokeCtrl.text = data.sunPokeCishu.toString();
    _zmPokeCtrl.text = data.zmPokeCishu.toString();
    _tianjiangCtrl.text = data.tianjianglihe.toString();
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
      touzi: int.tryParse(_touziCtrl.text) ?? 0,
      touzi2: int.tryParse(_touzi2Ctrl.text) ?? 0,
      coinYingtao: int.tryParse(_coinYingtaoCtrl.text) ?? 0,
      sunPokeCishu: int.tryParse(_sunPokeCtrl.text) ?? 0,
      zmPokeCishu: int.tryParse(_zmPokeCtrl.text) ?? 0,
      tianjianglihe: int.tryParse(_tianjiangCtrl.text) ?? 0,
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
    _touziCtrl.dispose();
    _touzi2Ctrl.dispose();
    _coinYingtaoCtrl.dispose();
    _sunPokeCtrl.dispose();
    _zmPokeCtrl.dispose();
    _tianjiangCtrl.dispose();
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
        child: _DesktopSaveEditorPage(
          chushisunCard: chushisunCard,
          coinController: _coinCtrl,
          touziController: _touziCtrl,
          touzi2Controller: _touzi2Ctrl,
          coinYingtaoController: _coinYingtaoCtrl,
          sunPokeController: _sunPokeCtrl,
          zmPokeController: _zmPokeCtrl,
          tianjiangController: _tianjiangCtrl,
          onUnlockAllPlants: _unlockAllPlants,
          onSave: _saveData,
        ),
      );
    }

    return KeyedSubtree(
      key: pageKey,
      child: _MobileSaveEditorPage(
        chushisunCard: chushisunCard,
        coinController: _coinCtrl,
        touziController: _touziCtrl,
        touzi2Controller: _touzi2Ctrl,
        coinYingtaoController: _coinYingtaoCtrl,
        sunPokeController: _sunPokeCtrl,
        zmPokeController: _zmPokeCtrl,
        tianjiangController: _tianjiangCtrl,
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

            final isDesktop = viewportWidth / 1.35 > viewportHeight;

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

class ChushisunCard extends StatefulWidget {
  const ChushisunCard({
    super.key,
    required this.controller,
    required this.initialSunlight,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int initialSunlight;
  final ValueChanged<String> onChanged;

  @override
  State<ChushisunCard> createState() => _ChushisunCardState();
}

class _ChushisunCardState extends State<ChushisunCard> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '初始阳光: ${widget.initialSunlight}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: _fieldKey,
              controller: widget.controller,
              decoration: const InputDecoration(
                labelText: '购买次数',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == "") {
                  return "输入为空";
                } else if (int.tryParse(value ?? '') == null) {
                  return '无效数字';
                }

                return null;
              },
              onChanged: (value) {
                widget.onChanged(value);
                _fieldKey.currentState?.validate();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileSaveEditorPage extends StatelessWidget {
  const _MobileSaveEditorPage({
    required this.chushisunCard,
    required this.coinController,
    required this.touziController,
    required this.touzi2Controller,
    required this.coinYingtaoController,
    required this.sunPokeController,
    required this.zmPokeController,
    required this.tianjiangController,
    required this.onUnlockAllPlants,
    required this.onSave,
  });

  final Widget chushisunCard;
  final TextEditingController coinController;
  final TextEditingController touziController;
  final TextEditingController touzi2Controller;
  final TextEditingController coinYingtaoController;
  final TextEditingController sunPokeController;
  final TextEditingController zmPokeController;
  final TextEditingController tianjiangController;
  final VoidCallback onUnlockAllPlants;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(title: '数值修改'),
          const SizedBox(height: 12),
          chushisunCard,
          const SizedBox(height: 20),
          const _SectionHeader(title: '金币与投资'),
          const SizedBox(height: 12),
          _TwoColumnFields(
            first: _NumberField(label: '金币数量', controller: coinController),
            second: _NumberField(label: '投资次数', controller: touziController),
          ),
          const SizedBox(height: 12),
          _TwoColumnFields(
            first: _NumberField(label: '货币投资次数', controller: touzi2Controller),
            second: const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          const _SectionHeader(title: '道具剩余次数'),
          const SizedBox(height: 12),
          _TwoColumnFields(
            first: _NumberField(
              label: '樱桃炸弹',
              controller: coinYingtaoController,
            ),
            second: _NumberField(label: '阳光精灵球', controller: sunPokeController),
          ),
          const SizedBox(height: 12),
          _TwoColumnFields(
            first: _NumberField(label: '僵尸精灵球', controller: zmPokeController),
            second: _NumberField(
              label: '天降礼盒',
              controller: tianjiangController,
            ),
          ),
          const SizedBox(height: 24),
          _ActionButtons(onUnlockAllPlants: onUnlockAllPlants, onSave: onSave),
        ],
      ),
    );
  }
}

class _DesktopSaveEditorPage extends StatelessWidget {
  const _DesktopSaveEditorPage({
    required this.chushisunCard,
    required this.coinController,
    required this.touziController,
    required this.touzi2Controller,
    required this.coinYingtaoController,
    required this.sunPokeController,
    required this.zmPokeController,
    required this.tianjiangController,
    required this.onUnlockAllPlants,
    required this.onSave,
  });

  final Widget chushisunCard;
  final TextEditingController coinController;
  final TextEditingController touziController;
  final TextEditingController touzi2Controller;
  final TextEditingController coinYingtaoController;
  final TextEditingController sunPokeController;
  final TextEditingController zmPokeController;
  final TextEditingController tianjiangController;
  final VoidCallback onUnlockAllPlants;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _DesktopPanel(
                  title: '数值修改',
                  subtitle: null,
                  children: [
                    chushisunCard,
                    const SizedBox(height: 16),
                    _SectionHeader(title: '金币与投资'),
                    const SizedBox(height: 12),
                    _TwoColumnFields(
                      first: _NumberField(
                        label: '金币数量',
                        controller: coinController,
                      ),
                      second: _NumberField(
                        label: '投资次数',
                        controller: touziController,
                      ),
                      third: _NumberField(
                        label: '货币投资次数',
                        controller: touzi2Controller,
                      ),
                      fourth: const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    _SectionHeader(title: '道具剩余次数'),
                    const SizedBox(height: 12),
                    _TwoColumnFields(
                      first: _NumberField(
                        label: '樱桃炸弹',
                        controller: coinYingtaoController,
                      ),
                      second: _NumberField(
                        label: '阳光精灵球',
                        controller: sunPokeController,
                      ),
                      third: _NumberField(
                        label: '僵尸精灵球',
                        controller: zmPokeController,
                      ),
                      fourth: _NumberField(
                        label: '天降礼盒',
                        controller: tianjiangController,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: _DesktopPanel(
                  title: '存档操作',
                  subtitle: null,
                  children: [
                    _ActionButtons(
                      onUnlockAllPlants: onUnlockAllPlants,
                      onSave: onSave,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopPanel extends StatelessWidget {
  const _DesktopPanel({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (subtitle != null) const SizedBox(height: 6),
            if (subtitle != null)
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 30),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DesktopSummaryCard extends StatelessWidget {
  const _DesktopSummaryCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(body),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onUnlockAllPlants, required this.onSave});

  final VoidCallback onUnlockAllPlants;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onUnlockAllPlants,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              side: const BorderSide(color: Colors.blueAccent),
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text('解锁全卡'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text('保存存档'),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _TwoColumnFields extends StatelessWidget {
  const _TwoColumnFields({
    required this.first,
    required this.second,
    this.third,
    this.fourth,
  });

  final Widget first;
  final Widget second;
  final Widget? third;
  final Widget? fourth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 12),
        Expanded(child: second),
        if (third != null) ...[
          const SizedBox(width: 12),
          Expanded(child: third!),
        ],
        if (fourth != null) ...[
          const SizedBox(width: 12),
          Expanded(child: fourth!),
        ],
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) =>
          (int.tryParse(value ?? '') ?? -1) < 0 ? '不能为负数' : null,
    );
  }
}
