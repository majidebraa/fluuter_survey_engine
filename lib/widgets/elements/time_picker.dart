import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/date_time_converter.dart';
import '../base_reactive_widget.dart';

class TimePickerWidget extends ReactiveSurveyWidget {
  const TimePickerWidget({super.key, required super.el, required super.engine});

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState
    extends ReactiveSurveyWidgetState<TimePickerWidget> {
  Future<void> _pickTime(BuildContext context, TimeOfDay? initial) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final local = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      final seconds = DateTimeConverter.uiTimeToSeconds(local);
      setValue(seconds);
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    final rawValue = value;
    final dt = DateTimeConverter.fromBackend(rawValue);

    String display = "--:--";
    TimeOfDay? initial;

    if (dt != null) {
      display = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      initial = TimeOfDay(hour: dt.hour, minute: dt.minute);
    }

    return GestureDetector(
      onTap: isReadOnly ? null : () => _pickTime(context, initial),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(display),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}

