import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class MatrixWidget extends StatelessWidget {
  final FormElement el;
  final SurveyEngine engine;

  const MatrixWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cols = el.columns ?? [];
    final rows = el.rows ?? [];

    if (el.visible == false) {
      return const SizedBox.shrink();
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          TableRow(children: [
            for (final c in cols)
              Padding(padding: const EdgeInsets.all(8.0), child: Text(c.name))
          ]),
          for (final r in rows)
            TableRow(children: [
              for (final c in cols)
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${r.name} / ${c.name}'))
            ]),
        ],
      )
    ]);
  }
}
