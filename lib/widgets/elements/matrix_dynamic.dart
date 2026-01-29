import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

class MatrixDynamicWidget extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const MatrixDynamicWidget({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  State<MatrixDynamicWidget> createState() => _MatrixDynamicWidgetState();
}

class _MatrixDynamicWidgetState extends State<MatrixDynamicWidget> {
  List<Map<String, dynamic>> rows = [];

  @override
  void initState() {
    super.initState();
    final existing = widget.engine.getValue(widget.el.name);
    if (existing is List) rows = List<Map<String, dynamic>>.from(existing);
  }

  @override
  Widget build(BuildContext context) {
    final cols = widget.el.columns ?? [];

    if (widget.el.visible == false) {
      return const SizedBox.shrink();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.el.title != null) Text(widget.el.title!),
      ...rows.asMap().entries.map((e) {
        final idx = e.key;
        final data = e.value;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text('Row ${idx + 1}'),
              for (final c in cols)
                TextField(
                  decoration: InputDecoration(labelText: c.name),
                  controller:
                      TextEditingController(text: data[c.name]?.toString()),
                  onChanged: (v) {
                    data[c.name] = v;
                    widget.engine.setValue(widget.el.name, rows);
                  },
                ),
              Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          rows.removeAt(idx);
                          widget.engine.setValue(widget.el.name, rows);
                        });
                      }))
            ]),
          ),
        );
      }).toList(),
      Row(children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                rows.add({});
                widget.engine.setValue(widget.el.name, rows);
              });
            },
            child: const Text('Add row'))
      ])
    ]);
  }
}
