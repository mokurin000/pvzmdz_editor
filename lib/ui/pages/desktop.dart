import 'package:flutter/material.dart';

import 'package:pvzmdz_editor/widgets/common.dart';

class DesktopSaveEditorPage extends StatelessWidget {
  const DesktopSaveEditorPage({
    super.key,
    required this.chushisunCard,
    required this.coinController,
    required this.maoliangController,
    required this.touziController,
    required this.touzi2Controller,
    required this.coinYingtaoController,
    required this.sunPokeController,
    required this.zmPokeController,
    required this.tianjiangController,
    required this.maoxianController,
    required this.maoxianIfaController,
    required this.maoxianSnowController,
    required this.wujincengController,
    required this.wujinceng2Controller,
    required this.wujinceng2LastController,
    required this.wujinceng3Controller,
    required this.onUnlockAllPlants,
    required this.onSave,
  });

  final Widget chushisunCard;
  final TextEditingController coinController;
  final TextEditingController maoliangController;
  final TextEditingController touziController;
  final TextEditingController touzi2Controller;
  final TextEditingController coinYingtaoController;
  final TextEditingController sunPokeController;
  final TextEditingController zmPokeController;
  final TextEditingController tianjiangController;
  final TextEditingController maoxianController;
  final TextEditingController maoxianIfaController;
  final TextEditingController maoxianSnowController;
  final TextEditingController wujincengController;
  final TextEditingController wujinceng2Controller;
  final TextEditingController wujinceng2LastController;
  final TextEditingController wujinceng3Controller;
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
                    SectionHeader(title: '金币与投资'),
                    const SizedBox(height: 12),
                    TwoColumnFields(
                      first: NumberField(
                        label: '金币数量',
                        controller: coinController,
                      ),
                      second: NumberField(
                        label: '猫粮',
                        controller: maoliangController,
                      ),
                      third: NumberField(
                        label: '投资次数',
                        controller: touziController,
                      ),
                      fourth: NumberField(
                        label: '货币投资次数',
                        controller: touzi2Controller,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(title: '道具剩余次数'),
                    const SizedBox(height: 12),
                    TwoColumnFields(
                      first: NumberField(
                        label: '樱桃炸弹',
                        controller: coinYingtaoController,
                      ),
                      second: NumberField(
                        label: '阳光精灵球',
                        controller: sunPokeController,
                      ),
                      third: NumberField(
                        label: '僵尸精灵球',
                        controller: zmPokeController,
                      ),
                      fourth: NumberField(
                        label: '天降礼盒',
                        controller: tianjiangController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(title: '关卡进度'),
                    const SizedBox(height: 12),
                    TwoColumnFields(
                      first: NumberField(
                        label: '冒险模式',
                        controller: maoxianController,
                      ),
                      second: NumberField(
                        label: 'Snow模式',
                        controller: maoxianSnowController,
                      ),
                      third: NumberField(
                        label: 'IFA模式',
                        controller: maoxianIfaController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionHeader(title: '无尽层数'),
                    const SizedBox(height: 12),
                    TwoColumnFields(
                      first: NumberField(
                        label: '冒险模式',
                        controller: wujincengController,
                      ),
                      second: NumberField(
                        label: '抽卡当前',
                        controller: wujinceng2Controller,
                      ),
                      third: NumberField(
                        label: '抽卡最高',
                        controller: wujinceng2LastController,
                      ),
                      fourth: NumberField(
                        label: 'IFA模式',
                        controller: wujinceng3Controller,
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
                    ActionButtons(
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
