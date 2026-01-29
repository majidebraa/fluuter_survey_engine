import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class TextInputWidget extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const TextInputWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
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
          decoration:
              InputDecoration(errorText: widget.engine.errors[widget.el.name]),
          readOnly: ro,
          onChanged: (v) => widget.engine.setValue(widget.el.name, v),
        ),
      ]),
    );
  }
}
