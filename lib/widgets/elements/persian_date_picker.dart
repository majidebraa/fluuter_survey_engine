import 'package:flutter/material.dart';
import 'package:flutter_survey_engine/extenssion/jalali_extenstions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../common/jalali_date_picker_dialog.dart';
import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

/// Survey widget for Jalali date picker with border
class PersianDatePickerWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const PersianDatePickerWidget(
      {Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final val = engine.getValue(el.name) as String?;
    final ro = engine.isReadOnly(el);

    // Display string
    String display = 'تاریخ را انتخاب کنید';
    Jalali? selectedJalali;
    if (val != null && val.isNotEmpty) {
      try {
        final dt = DateTime.parse(val);
        selectedJalali = Jalali.fromDateTime(dt);
        display = selectedJalali.formatFullDate();
      } catch (_) {}
    }

    if (el.visible == false) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Border color
        borderRadius: BorderRadius.circular(8), // Rounded corners
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
                  engine.setValue(
                      el.name, picked.toDateTime().toIso8601String());
                }
              },
      ),
    );
  }
}
