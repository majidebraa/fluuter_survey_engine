import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class RadioGroupWidget extends ReactiveSurveyWidget {
  const RadioGroupWidget({super.key, required super.el, required super.engine});

  @override
  State<RadioGroupWidget> createState() => _RadioGroupWidgetState();
}

class _RadioGroupWidgetState
    extends ReactiveSurveyWidgetState<RadioGroupWidget> {
  @override
  Widget buildContent(BuildContext context) {
    final choices = widget.el.choices ?? [];
    final current = value; // from ReactiveSurveyWidgetState
    final readOnly = isReadOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...choices.map(
          (choice) => RadioListTile<dynamic>(
            value: choice,
            groupValue: current,
            title: Text(choice.toString()),
            onChanged: readOnly ? null : (v) => setValue(v),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
