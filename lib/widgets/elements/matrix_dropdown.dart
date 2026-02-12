import 'package:flutter/material.dart';

import '../../models/form_models.dart';
import '../base_reactive_widget.dart';
import '../survey_renderer.dart';

class MatrixDropdownWidget extends ReactiveSurveyWidget {
  const MatrixDropdownWidget({
    super.key,
    required super.el,
    required super.engine,
  });

  @override
  State<MatrixDropdownWidget> createState() => _MatrixDropdownWidgetState();
}

class _MatrixDropdownWidgetState
    extends ReactiveSurveyWidgetState<MatrixDropdownWidget> {
  final ScrollController _scroll = ScrollController();

  @override
  Widget buildContent(BuildContext context) {
    final rows = widget.el.rows ?? [];
    final columns = widget.el.columns ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          columnWidths: {
            0: IntrinsicColumnWidth(), // first column (row names)
            for (int i = 1; i <= columns.length; i++)
              i: const IntrinsicColumnWidth(),
          },
          children: _buildRows(context, rows, columns),
        ),
      ),
    );
  }

  List<TableRow> _buildRows(
      BuildContext context, List<RowSchema> rows, List<ColumnSchema> columns) {
    final List<TableRow> list = [];

    // Header row
    list.add(
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFDFDFDF)),
        children: [
          const TableCell(child: SizedBox()),
          ...columns.map((col) => TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(col.name),
                ),
              )),
        ],
      ),
    );

    // Body rows
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      final rowKey = row.text ?? "";

      list.add(
        TableRow(
          decoration:
              i % 2 == 1 ? const BoxDecoration(color: Color(0xFFF4F4F4)) : null,
          children: [
            // Row name
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(row.name),
              ),
            ),
            // Cells
            ...columns.map((col) => TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: SizedBox(
                    width: 150, // optional: minimum cell width
                    child: _buildCellEditor(rowKey, col),
                  ),
                )),
          ],
        ),
      );
    }

    return list;
  }

  Widget _buildCellEditor(String rowKey, ColumnSchema col) {
    final currentValue = (value is Map) ? value : {};
    final rowMap = (currentValue[rowKey] is Map) ? currentValue[rowKey] : {};
    final cellValue = rowMap[col.name];

    final fieldEl = FormElement(
      name: "${widget.el.name}.$rowKey.${col.name}",
      type: col.cellType ?? "dropdown",
      title: null,
      choices: col.choices ?? widget.el.choices,
    );

    return SurveyRenderer.buildElementStatic(
      context: context,
      el: fieldEl,
      engine: widget.engine,
      onChanged: (newValue) {
        print("newValue$newValue");

        final updated = <String, dynamic>{};
        updated.addAll((value is Map) ? value : {});

        // ensure row exists
        updated[rowKey] = Map<String, dynamic>.from(updated[rowKey] ?? {});

        // remove empty values (keeps JSON clean)
        if (newValue == null || newValue == "" || newValue == []) {
          updated[rowKey].remove(col.name);
        } else {
          updated[rowKey][col.name] = newValue;
        }
        print("updated$updated");
        setValue(updated);
      },
    );
  }
}
