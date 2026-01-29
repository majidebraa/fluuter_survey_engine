import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class TimePicker extends StatelessWidget {
  final SurveyEngine engine;
  final FormElement el;

  const TimePicker({
    super.key,
    required this.engine,
    required this.el,
  });

  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final formatted = _formatTime(picked);
      engine.setValue(el.name, formatted);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt); // 24-hour format
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: engine,
      builder: (context, _) {
        final isVisible = engine.isVisible(el);
        if (!isVisible) return const SizedBox.shrink();

        final value = engine.getValue(el.name);
        final displayText = value ?? '--:--';

        if (el.visible == false) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: engine.isReadOnly(el)
              ? null
              : () {
                  TimeOfDay? initial;
                  if (value != null && value is String && value.isNotEmpty) {
                    final parts = value.split(':');
                    if (parts.length == 2) {
                      final h = int.tryParse(parts[0]);
                      final m = int.tryParse(parts[1]);
                      if (h != null && m != null) {
                        initial = TimeOfDay(hour: h, minute: m);
                      }
                    }
                  }
                  _pickTime(context, initial);
                },
          child: Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.access_time, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
