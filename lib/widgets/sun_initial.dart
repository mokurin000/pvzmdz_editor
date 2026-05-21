import 'package:flutter/material.dart';

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
