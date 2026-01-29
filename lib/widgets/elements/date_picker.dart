import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class DatePickerWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const DatePickerWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final val = engine.getValue(el.name) as String?;
    final ro = engine.isReadOnly(el);
    String display = val ?? 'Select date';
    try {
      if (val != null && val.isNotEmpty) {
        final dt = DateTime.parse(val);
        final j = Jalali.fromDateTime(dt.toLocal());
        display = '${j /*.formatCompactDate()*/}';
      }
    } catch (_) {}
    if (el.visible == false) {
      return const SizedBox.shrink();
    }
    return ListTile(
      subtitle: Text(display),
      onTap: ro
          ? null
          : () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              if (picked != null)
                engine.setValue(el.name, picked.toIso8601String());
            },
    );
  }
}
