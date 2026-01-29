import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class CheckboxMultiWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const CheckboxMultiWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final choices = el.choices ?? [];
    final current = (engine.getValue(el.name) as List<dynamic>?) ?? [];
    final ro = engine.isReadOnly(el);

    if (el.visible == false) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ...choices.map((c) {
        final checked = current.contains(c);
        return CheckboxListTile(
          title: Text(c.toString()),
          value: checked,
          onChanged: ro
              ? null
              : (v) {
                  final list = List<dynamic>.from(current);
                  if (v == true)
                    list.add(c);
                  else
                    list.remove(c);
                  engine.setValue(el.name, list);
                },
        );
      }).toList(),
      if (engine.errors[el.name] != null)
        Text(engine.errors[el.name]!,
            style: const TextStyle(color: Colors.red)),
    ]);
  }
}
