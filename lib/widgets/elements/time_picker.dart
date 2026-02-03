import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
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
      display =
          "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      initial = TimeOfDay(hour: dt.hour, minute: dt.minute);
    }

    // --- READONLY COLORS ---
    final bool ro = isReadOnly;
    final Color borderColor = ro
        ? AppColors.greyReadOnlyColor
        : AppColors.primaryColor;
    final Color bgColor = ro
        ? AppColors.greyReadOnlyColor
        : AppColors.whiteColor;
    final Color textColor = ro ? AppColors.greyColor : AppColors.blackColor;
    final Color iconColor = ro ? Colors.grey : AppColors.primaryColor;

    return GestureDetector(
      onTap: ro ? null : () => _pickTime(context, initial),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(display, style: TextStyle(color: textColor)),
            Icon(Icons.access_time, color: iconColor),
          ],
        ),
      ),
    );
  }
}
