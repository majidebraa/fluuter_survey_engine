import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class CommentInputWidget extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const CommentInputWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  late TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(
        text: widget.engine.getValue(widget.el.name)?.toString());
  }

  @override
  Widget build(BuildContext context) {
    final ro = widget.engine.isReadOnly(widget.el);

    if (widget.el.visible == false) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: ctrl,
          maxLines: 4,
          readOnly: ro,
          decoration:
              InputDecoration(errorText: widget.engine.errors[widget.el.name]),
          onChanged: (v) => widget.engine.setValue(widget.el.name, v),
        ),
      ]),
    );
  }
}
