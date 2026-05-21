import 'package:flutter/material.dart';

import 'package:pvzmdz_editor/widgets/common.dart';

class MobileSaveEditorPage extends StatelessWidget {
  const MobileSaveEditorPage({
    super.key,
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
          const SectionHeader(title: '数值修改'),
          const SizedBox(height: 12),
          chushisunCard,
          const SizedBox(height: 20),
          const SectionHeader(title: '金币与投资'),
          const SizedBox(height: 12),
          TwoColumnFields(
            first: NumberField(label: '金币数量', controller: coinController),
            second: NumberField(label: '投资次数', controller: touziController),
          ),
          const SizedBox(height: 12),
          TwoColumnFields(
            first: NumberField(label: '货币投资次数', controller: touzi2Controller),
            second: const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: '道具剩余次数'),
          const SizedBox(height: 12),
          TwoColumnFields(
            first: NumberField(
              label: '樱桃炸弹',
              controller: coinYingtaoController,
            ),
            second: NumberField(label: '阳光精灵球', controller: sunPokeController),
          ),
          const SizedBox(height: 12),
          TwoColumnFields(
            first: NumberField(label: '僵尸精灵球', controller: zmPokeController),
            second: NumberField(label: '天降礼盒', controller: tianjiangController),
          ),
          const SizedBox(height: 24),
          ActionButtons(onUnlockAllPlants: onUnlockAllPlants, onSave: onSave),
        ],
      ),
    );
  }
}
