import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class TextInputWidget extends ReactiveSurveyWidget {
  const TextInputWidget({super.key, required super.el, required super.engine});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends ReactiveSurveyWidgetState<TextInputWidget> {
  TextEditingController? ctrl;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    ctrl = TextEditingController(text: value?.toString() ?? '');
  }

  @override
  void dispose() {
    ctrl?.dispose();
    super.dispose();
  }

  @override
  void onEngineUpdate() {
    // Only update if controller is initialized
    if (ctrl == null) return;

    final newValue = value?.toString() ?? '';
    if (ctrl!.text != newValue) {
      ctrl!.text = newValue;
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: ctrl,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          errorText: error,
          border: const OutlineInputBorder(),
        ),
        onChanged: setValue,
      ),
    );
  }
}
