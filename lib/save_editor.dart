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
  late GameData _data;

  // 输入控制器
  final TextEditingController _chushisunCtrl = TextEditingController();
  final TextEditingController _coinCtrl = TextEditingController();
  final TextEditingController _touziCtrl = TextEditingController();
  final TextEditingController _touzi2Ctrl = TextEditingController();
  final TextEditingController _coinYingtaoCtrl = TextEditingController();
  final TextEditingController _sunPokeCtrl = TextEditingController();
  final TextEditingController _zmPokeCtrl = TextEditingController();
  final TextEditingController _tianjiangCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String? rawData = await readGameSaveData();
    setState(() {
      if (rawData != null) {
        _data = GameData.fromJson(jsonDecode(rawData));
      } else {
        _data = GameData.defaultData();
      }

      // 初始化控制器
      _chushisunCtrl.text = _data.chushisun.toString();
      _coinCtrl.text = _data.coin.toString();
      _touziCtrl.text = _data.touzi.toString();
      _touzi2Ctrl.text = _data.touzi2.toString();
      _coinYingtaoCtrl.text = _data.coinYingtao.toString();
      _sunPokeCtrl.text = _data.sunPokeCishu.toString();
      _zmPokeCtrl.text = _data.zmPokeCishu.toString();
      _tianjiangCtrl.text = _data.tianjianglihe.toString();
    });
  }

  int get initialSunlight => 50 + 25 * (_data.chushisun);

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final newData = _data.copyWith(
      chushisun: int.tryParse(_chushisunCtrl.text) ?? 0,
      coin: int.tryParse(_coinCtrl.text) ?? 0,
      touzi: int.tryParse(_touziCtrl.text) ?? 0,
      touzi2: int.tryParse(_touzi2Ctrl.text) ?? 0,
      coinYingtao: int.tryParse(_coinYingtaoCtrl.text) ?? 0,
      sunPokeCishu: int.tryParse(_sunPokeCtrl.text) ?? 0,
      zmPokeCishu: int.tryParse(_zmPokeCtrl.text) ?? 0,
      tianjianglihe: int.tryParse(_tianjiangCtrl.text) ?? 0,
      // 关闭反作弊标记
      chuizhitongbu: false,
    );

    await writeGameSaveData(jsonEncode(newData.toJson()));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('存档修改成功！'), backgroundColor: Colors.green),
      );
    }

    // 重新加载显示最新数据
    setState(() => _data = newData);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('抽卡版存档修改器'),
        backgroundColor: Colors.orange[700],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '基础数值修改',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 初始阳光
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '初始阳光购买次数',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _chushisunCtrl,
                        decoration: const InputDecoration(
                          labelText: '购买次数 (≥0)',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (int.tryParse(v ?? '') ?? -1) < 0 ? '必须≥0' : null,
                        onChanged: (sun) => setState(() {
                          _data = _data.copyWith(chushisun: int.tryParse(sun));
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '当前初始阳光：$initialSunlight',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 金币与投资
              _buildNumberField('金币数量', _coinCtrl),
              _buildNumberField('投资次数', _touziCtrl),
              _buildNumberField('货币投资次数', _touzi2Ctrl),

              const Divider(height: 32),

              const Text(
                '道具剩余次数',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _buildNumberField('樱桃炸弹', _coinYingtaoCtrl),
              _buildNumberField('阳光精灵球', _sunPokeCtrl),
              _buildNumberField('僵尸精灵球', _zmPokeCtrl),
              _buildNumberField('天降礼盒', _tianjiangCtrl),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('保存存档'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (v) => (int.tryParse(v ?? '') ?? -1) < 0 ? '不能为负数' : null,
      ),
    );
  }
}
