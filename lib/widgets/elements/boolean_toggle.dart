import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class BooleanToggleWidget extends ReactiveSurveyWidget {
  const BooleanToggleWidget(
      {super.key, required super.el, required super.engine});

  @override
  State<BooleanToggleWidget> createState() => _BooleanToggleWidgetState();
}

class _BooleanToggleWidgetState
    extends ReactiveSurveyWidgetState<BooleanToggleWidget> {
  @override
  void onEngineUpdate() {
    if (mounted) setState(() {}); // rebuild when engine updates
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final current = (value as bool?) ?? false;

    return SwitchListTile(
      title: Text(widget.el.title ?? widget.el.name),
      value: current,
      onChanged: isReadOnly ? null : setValue,
    );
  }
}
