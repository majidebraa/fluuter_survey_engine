import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../base_reactive_widget.dart';

class DatePickerWidget extends ReactiveSurveyWidget {
  const DatePickerWidget({super.key, required super.el, required super.engine});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState
    extends ReactiveSurveyWidgetState<DatePickerWidget> {
  @override
  void onEngineUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget buildContent(BuildContext context) {
    final val = value as String?;
    final ro = isReadOnly;

    // Default display
    String display = 'Select date';
    try {
      if (val != null && val.isNotEmpty) {
        final dt = DateTime.parse(val);
        final j = Jalali.fromDateTime(dt.toLocal());
        display = '${j.year}/${j.month}/${j.day}';
      }
    } catch (_) {}

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return ListTile(
      subtitle: Text(display),
      onTap: ro
          ? null
          : () async {
              final now = val != null && val.isNotEmpty
                  ? DateTime.parse(val)
                  : DateTime.now();

              final picked = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (picked != null) setValue(picked.toIso8601String());
            },
    );
  }
}
