import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class DropdownWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  DropdownWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final choices = el.choices ?? [];
    final current = engine.getValue(el.name);
    final safeValue = choices.contains(current) ? current : null;

    final ro = engine.isReadOnly(el);

    if (el.visible == false) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DropdownButton<dynamic>(
          isExpanded: true,
          value: safeValue,
          hint: const Text('Select'),
          items: choices
              .map<DropdownMenuItem<dynamic>>(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.toString()),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (ro) return;
            engine.setValue(el.name, v);
          },
        ),
        if (engine.errors[el.name] != null)
          Text(engine.errors[el.name]!,
              style: const TextStyle(color: Colors.red)),
      ]),
    );
  }
}
