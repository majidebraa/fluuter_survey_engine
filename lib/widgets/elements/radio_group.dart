import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class RadioGroupWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const RadioGroupWidget({
    Key? key,
    required this.el,
    required this.engine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final choices = el.choices ?? [];
    final current = engine.getValue(el.name);
    final ro = engine.isReadOnly(el);

    if (el.visible == false) {
      return const SizedBox.shrink();
    }

    return RadioGroup<dynamic>(
      groupValue: current,
      onChanged: (value) {
        if (ro) return; // block changes when read-only
        engine.setValue(el.name, value);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...choices.map(
            (c) => RadioListTile<dynamic>(
              value: c,
              title: Text(c.toString()),
            ),
          ),
          if (engine.errors[el.name] != null)
            Text(
              engine.errors[el.name]!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
