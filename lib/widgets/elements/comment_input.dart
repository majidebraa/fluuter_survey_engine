import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class CommentInputWidget extends ReactiveSurveyWidget {
  const CommentInputWidget({
    super.key,
    required super.el,
    required super.engine
  });

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState
    extends ReactiveSurveyWidgetState<CommentInputWidget> {
  late TextEditingController ctrl;

  @override
  void initState() {
    // Initialize controller BEFORE calling super
    ctrl = TextEditingController(text: value?.toString() ?? '');
    super.initState();
  }

  @override
  void onEngineUpdate() {
    final newValue = value?.toString() ?? '';
    if (ctrl.text != newValue) {
      ctrl.text = newValue;
    }
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
