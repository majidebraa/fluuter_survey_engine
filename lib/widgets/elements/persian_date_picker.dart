import 'package:flutter/material.dart';
import 'package:flutter_survey_engine/extenssion/jalali_extenstions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../common/jalali_date_picker_dialog.dart';
import '../../utils/date_time_converter.dart';
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
    final readOnly = isReadOnly;
    final rawValue = value;

    // Convert backend → local datetime
    final dt = DateTimeConverter.fromBackend(rawValue);

    Jalali? selectedJalali;
    String display = "تاریخ را انتخاب کنید";

    if (dt != null) {
      selectedJalali = Jalali.fromDateTime(dt);
      display = selectedJalali.formatFullDate();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(display, textAlign: TextAlign.right),
        trailing: const Icon(Icons.calendar_month),
        onTap: readOnly
            ? null
            : () async {
          final initial = selectedJalali ?? Jalali.now();

          final picked = await showDialog<Jalali>(
            context: context,
            builder: (_) => JalaliDatePickerDialog(initialDate: initial),
          );

          if (picked != null) {
            final localDt = picked.toDateTime();
            final seconds = DateTimeConverter.uiDateToSeconds(localDt);
            setValue(seconds);
          }
        },
      ),
    );
  }
}

