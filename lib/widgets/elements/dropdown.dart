import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class DropdownWidget extends ReactiveSurveyWidget {
  const DropdownWidget({super.key, required super.el, required super.engine});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends ReactiveSurveyWidgetState<DropdownWidget> {
  @override
  void onEngineUpdate() {
    // Just rebuild when engine value changes
    if (mounted) setState(() {});
  }

  @override
  Widget buildContent(BuildContext context) {
    final choices = widget.el.choices ?? [];
    final current = value;
    final safeValue = choices.contains(current) ? current : null;

    if (!isVisible) {
      // Still evaluates/calculates value in background
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            onChanged: isReadOnly ? null : setValue,
          ),
          if (error != null)
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
