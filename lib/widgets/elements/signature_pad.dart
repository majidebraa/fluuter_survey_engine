import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class SignaturePadWidget extends ReactiveSurveyWidget {
  const SignaturePadWidget(
      {super.key, required super.el, required super.engine});

  @override
  State<SignaturePadWidget> createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState
    extends ReactiveSurveyWidgetState<SignaturePadWidget> {
  void _sign() {
    final value = 'signed:${DateTime.now().toIso8601String()}';
    setValue(value);
  }

  @override
  Widget buildContent(BuildContext context) {
    final readOnly = isReadOnly;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 120,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Text('Signature area (placeholder)'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: readOnly ? null : _sign,
          child: const Text('Sign'),
        ),
      ],
    );
  }
}
