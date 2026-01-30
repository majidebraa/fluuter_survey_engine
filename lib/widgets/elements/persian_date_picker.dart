import 'package:flutter/material.dart';
import 'package:flutter_survey_engine/extenssion/jalali_extenstions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../common/jalali_date_picker_dialog.dart';
import '../base_reactive_widget.dart';

class PersianDatePickerWidget extends ReactiveSurveyWidget {
  const PersianDatePickerWidget({
    super.key,
    required super.el,
    required super.engine,
  });

  @override
  State<PersianDatePickerWidget> createState() =>
      _PersianDatePickerWidgetState();
}

class _PersianDatePickerWidgetState
    extends ReactiveSurveyWidgetState<PersianDatePickerWidget> {
  @override
  Widget buildContent(BuildContext context) {
    final ro = isReadOnly;

    // Current value
    final val = value as String?;
    String display = 'تاریخ را انتخاب کنید';
    Jalali? selectedJalali;

    if (val != null && val.isNotEmpty) {
      try {
        final dt = DateTime.parse(val);
        selectedJalali = Jalali.fromDateTime(dt);
        display = selectedJalali.formatFullDate();
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(display, textAlign: TextAlign.right),
        trailing: const Icon(Icons.calendar_month),
        onTap: ro
            ? null
            : () async {
                final now = selectedJalali ?? Jalali.now();
                final picked = await showDialog<Jalali>(
                  context: context,
                  builder: (_) => JalaliDatePickerDialog(initialDate: now),
                );

                if (picked != null) {
                  setValue(picked.toDateTime().toIso8601String());
                }
              },
      ),
    );
  }
}
