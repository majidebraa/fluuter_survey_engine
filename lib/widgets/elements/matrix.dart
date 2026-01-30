import 'package:flutter/material.dart';

import '../base_reactive_widget.dart';

class MatrixWidget extends ReactiveSurveyWidget {
  const MatrixWidget({super.key, required super.el, required super.engine});

  @override
  State<MatrixWidget> createState() => _MatrixWidgetState();
}

class _MatrixWidgetState extends ReactiveSurveyWidgetState<MatrixWidget> {
  @override
  void onEngineUpdate() {
    // Rebuild when engine changes (values, visibility, errors)
    if (mounted) setState(() {});
  }

  @override
  Widget buildContent(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final cols = widget.el.columns ?? [];
    final rows = widget.el.rows ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.el.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.el.title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            // Header row
            TableRow(
              children: [
                for (final c in cols)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            // Data rows
            for (final r in rows)
              TableRow(
                children: [
                  for (final c in cols)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          '${r.name} / ${c.name}'), // You can customize to show engine values
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
