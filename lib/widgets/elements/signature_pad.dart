import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class SignaturePadWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const SignaturePadWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ro = engine.isReadOnly(el);

    if (el.visible == false) {
      return const SizedBox.shrink();
    }

    return Column(children: [
      Container(
          height: 120,
          color: Colors.grey.shade200,
          child: const Center(child: Text('Signature area (placeholder)'))),
      ElevatedButton(
          onPressed: ro
              ? null
              : () {
                  engine.setValue(
                      el.name, 'signed:${DateTime.now().toIso8601String()}');
                },
          child: const Text('Sign'))
    ]);
  }
}
