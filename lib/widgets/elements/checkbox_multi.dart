import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class CheckboxMultiWidget extends ReactiveSurveyWidget {
  const CheckboxMultiWidget({
    super.key,
    required super.el,
    required super.engine,
  });

  @override
  State<CheckboxMultiWidget> createState() => _CheckboxMultiWidgetState();
}

class _CheckboxMultiWidgetState
    extends ReactiveSurveyWidgetState<CheckboxMultiWidget> {
  @override
  void onEngineUpdate() {
    // No extra state needed, just rebuild
    if (mounted) setState(() {});
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final choices = widget.el.choices ?? [];
    final current = (value as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in choices)
          CheckboxListTile(
            title: Text(c.toString()),
            value: current.contains(c),
            onChanged: isReadOnly
                ? null
                : (v) {
                    final list = List<dynamic>.from(current);
                    if (v == true) {
                      list.add(c);
                    } else {
                      list.remove(c);
                    }
                    setValue(list);
                  },
          ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}
