import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class MatrixDynamicWidget extends ReactiveSurveyWidget {
  const MatrixDynamicWidget(
      {super.key, required super.el, required super.engine});

  @override
  State<MatrixDynamicWidget> createState() => _MatrixDynamicWidgetState();
}

class _MatrixDynamicWidgetState
    extends ReactiveSurveyWidgetState<MatrixDynamicWidget> {
  // Keep controllers per row & column
  final List<Map<String, TextEditingController>> _controllers = [];

  List<Map<String, dynamic>> get rows {
    final val = value;
    if (val is List<Map<String, dynamic>>) return val;
    return [];
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers for existing rows
    _syncControllersWithRows();
  }

  void _syncControllersWithRows() {
    _controllers.clear();
    for (final row in rows) {
      final map = <String, TextEditingController>{};
      for (final col in widget.el.columns ?? []) {
        map[col.name] =
            TextEditingController(text: row[col.name]?.toString() ?? '');
      }
      _controllers.add(map);
    }
  }

  void _addRow() {
    final newRow = <String, dynamic>{};
    rows.asMap(); // just to trigger getter
    rows.add(newRow);
    _syncControllersWithRows();
    setValue(rows);
  }

  void _removeRow(int index) {
    if (index < 0 || index >= rows.length) return;
    rows.removeAt(index);
    _controllers.removeAt(index);
    setValue(rows);
  }

  @override
  void onEngineUpdate() {
    // Sync controllers if rows changed externally
    _syncControllersWithRows();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final cols = widget.el.columns ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.el.title != null)
          Text(widget.el.title!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (var i = 0; i < rows.length; i++)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Row ${i + 1}'),
                  for (final col in cols)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TextField(
                        controller: _controllers[i][col.name],
                        decoration: InputDecoration(labelText: col.name),
                        onChanged: (v) {
                          rows[i][col.name] = v;
                          setValue(rows);
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeRow(i),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ElevatedButton(
          onPressed: _addRow,
          child: const Text('Add row'),
        ),
      ],
    );
  }
}
