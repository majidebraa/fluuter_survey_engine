import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class CommentInputWidget extends ReactiveSurveyWidget {
  const CommentInputWidget(
      {super.key, required super.el, required super.engine});

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState
    extends ReactiveSurveyWidgetState<CommentInputWidget> {
  late TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: value?.toString() ?? '');
  }

  @override
  void onEngineUpdate() {
    // Update controller if value changed externally
    final newValue = value?.toString() ?? '';
    if (ctrl.text != newValue) {
      ctrl.text = newValue;
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.el.title != null)
            Text(
              widget.el.title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            maxLines: 4,
            readOnly: isReadOnly,
            decoration: InputDecoration(
              errorText: error,
              border: const OutlineInputBorder(),
            ),
            onChanged: setValue,
          ),
        ],
      ),
    );
  }
}
