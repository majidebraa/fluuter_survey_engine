import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class RadioGroupWidget extends ReactiveSurveyWidget {
  final void Function(dynamic)? onChanged;

  const RadioGroupWidget({
    super.key,
    required super.el,
    required super.engine,
    this.onChanged,
  });

  @override
  State<RadioGroupWidget> createState() => _RadioGroupWidgetState();
}

class _RadioGroupWidgetState
    extends ReactiveSurveyWidgetState<RadioGroupWidget> {
  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final choices = widget.el.choices ?? [];
    final current = value;
    final readOnly = isReadOnly;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: choices.map((choice) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<dynamic>(
                    value: choice,
                    groupValue: current,
                    onChanged: readOnly
                        ? null
                        : (v) {
                            setValue(v);
                            widget.onChanged?.call(v);
                          },
                  ),
                  Text(choice.toString()),
                ],
              );
            }).toList(),
          ),

          // Error display
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
