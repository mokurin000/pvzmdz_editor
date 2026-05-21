import 'dart:convert';

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
      _syncControllers(data);
    });
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

    await writeGameSaveData(jsonEncode(newData.toJson()));

    if (!mounted) {
      return;
    }

    setState(() => _data = newData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('存档修改成功！'), backgroundColor: Colors.green),
    );
  }

  void _unlockAllPlants() {
    final currentData = _data;
    if (currentData == null) {
      return;
    }

    setState(() {
      _data = currentData.copyWith(scores: allPlantScores);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已解锁全部植物')));
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 960) {
                      return _DesktopSaveEditorPage(
                        chushisunCard: ChushisunCard(
                          controller: _chushisunCtrl,
                          initialSunlight: initialSunlight,
                          onChanged: (sun) {
                            final currentData = _data;
                            if (currentData == null) return;
                            setState(() {
                              _data = currentData.copyWith(
                                chushisun: int.tryParse(sun) ?? 0,
                              );
                            });
                          },
                        ),
                        coinController: _coinCtrl,
                        touziController: _touziCtrl,
                        touzi2Controller: _touzi2Ctrl,
                        coinYingtaoController: _coinYingtaoCtrl,
                        sunPokeController: _sunPokeCtrl,
                        zmPokeController: _zmPokeCtrl,
                        tianjiangController: _tianjiangCtrl,
                        onUnlockAllPlants: _unlockAllPlants,
                        onSave: _saveData,
                      );
                    }

                    return _MobileSaveEditorPage(
                      chushisunCard: ChushisunCard(
                        controller: _chushisunCtrl,
                        initialSunlight: initialSunlight,
                        onChanged: (sun) {
                          final currentData = _data;
                          if (currentData == null) return;
                          setState(() {
                            _data = currentData.copyWith(
                              chushisun: int.tryParse(sun) ?? 0,
                            );
                          });
                        },
                      ),
                      coinController: _coinCtrl,
                      touziController: _touziCtrl,
                      touzi2Controller: _touzi2Ctrl,
                      coinYingtaoController: _coinYingtaoCtrl,
                      sunPokeController: _sunPokeCtrl,
                      zmPokeController: _zmPokeCtrl,
                      tianjiangController: _tianjiangCtrl,
                      onUnlockAllPlants: _unlockAllPlants,
                      onSave: _saveData,
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class ChushisunCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '初始阳光购买次数',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: '购买次数 (>=0)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  (int.tryParse(value ?? '') ?? -1) < 0 ? '必须>=0' : null,
              onChanged: onChanged,
            ),
            const SizedBox(height: 14),
            _SunlightPreview(value: initialSunlight),
          ],
        ),
      ),
    );
  }
}

class _SunlightPreview extends StatelessWidget {
  const _SunlightPreview({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE7F3FF), Color(0xFFD4E7FF)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '当前初始阳光：$value',
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1565C0),
          fontWeight: FontWeight.w700,
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader(title: '基础数值修改'),
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
          first: _NumberField(label: '樱桃炸弹', controller: coinYingtaoController),
          second: _NumberField(label: '阳光精灵球', controller: sunPokeController),
        ),
        const SizedBox(height: 12),
        _TwoColumnFields(
          first: _NumberField(label: '僵尸精灵球', controller: zmPokeController),
          second: _NumberField(label: '天降礼盒', controller: tianjiangController),
        ),
        const SizedBox(height: 24),
        _ActionButtons(onUnlockAllPlants: onUnlockAllPlants, onSave: onSave),
      ],
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
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _DesktopPanel(
                    title: '核心编辑',
                    subtitle: '围绕数值修改和保存操作',
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
                      ),
                      const SizedBox(height: 12),
                      _TwoColumnFields(
                        first: _NumberField(
                          label: '货币投资次数',
                          controller: touzi2Controller,
                        ),
                        second: const SizedBox.shrink(),
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
                      ),
                      const SizedBox(height: 12),
                      _TwoColumnFields(
                        first: _NumberField(
                          label: '僵尸精灵球',
                          controller: zmPokeController,
                        ),
                        second: _NumberField(
                          label: '天降礼盒',
                          controller: tianjiangController,
                        ),
                      ),
                      const SizedBox(height: 20),
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
  final String subtitle;
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
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),
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
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4EAF2)),
      ),
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
            child: const Text('一键解锁全部植物'),
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
  const _TwoColumnFields({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 12),
        Expanded(child: second),
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
