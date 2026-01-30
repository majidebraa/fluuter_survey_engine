import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base_reactive_widget.dart';

class TimePickerWidget extends ReactiveSurveyWidget {
  const TimePickerWidget({super.key, required super.el, required super.engine});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState
    extends ReactiveSurveyWidgetState<TimePickerWidget> {
  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final formatted = _formatTime(picked);
      setValue(formatted);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dt); // 24-hour 24:00 format
  }

  @override
  Widget buildContent(BuildContext context) {
    final valueStr = value?.toString() ?? '--:--';
    final readOnly = isReadOnly;

    // Parse TimeOfDay for initial picker
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

    return GestureDetector(
      onTap: readOnly ? null : () => _pickTime(context, initial),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              valueStr,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
