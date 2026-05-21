library;

import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required this.onUnlockAllPlants, required this.onSave});

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

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

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

class TwoColumnFields extends StatelessWidget {
  const TwoColumnFields({super.key, 
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

class NumberField extends StatelessWidget {
  const NumberField({super.key, required this.label, required this.controller});

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
