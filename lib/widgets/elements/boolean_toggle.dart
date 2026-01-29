import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class BooleanToggleWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const BooleanToggleWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final current = engine.getValue(el.name) as bool? ?? false;
    final ro = engine.isReadOnly(el);

    if (el.visible == false) {
      return const SizedBox.shrink();
    }
    return SwitchListTile(
      //title: Text(el.title ?? el.name),
      value: current,
      onChanged: ro ? null : (v) => engine.setValue(el.name, v),
    );
  }
}
