import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class CheckboxMultiWidget extends ReactiveSurveyWidget {
  final void Function(List<dynamic>)? onChanged;

  const CheckboxMultiWidget({
    super.key,
    required super.el,
    required super.engine,
    this.onChanged,
  });

  @override
  State<CheckboxMultiWidget> createState() => _CheckboxMultiWidgetState();
}

class _CheckboxMultiWidgetState
    extends ReactiveSurveyWidgetState<CheckboxMultiWidget> {
  @override
  void onEngineUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final choices = widget.el.choices ?? [];
    final current = (value as List<dynamic>?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: choices.map((c) {
          final checked = current.contains(c);

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: checked,
                onChanged: isReadOnly
                    ? null
                    : (v) {
                        final list = List<dynamic>.from(current);
                        if (v == true) {
                          list.add(c);
                        } else {
                          list.remove(c);
                        }

                        // Update value in reactive engine
                        setValue(list);

                        // Call callback if provided
                        widget.onChanged?.call(list);
                      },
              ),
              Text(c.toString()),
            ],
          );
        }).toList(),
      ),
    );
  }
}
