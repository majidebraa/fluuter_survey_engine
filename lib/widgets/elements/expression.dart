import 'package:flutter/material.dart';

import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

/// Expression widget for SurveyJS-like forms
/// Supports JS-like expressions with {FIELD_NAME} placeholders
/// Shows initial value from formData if expression not ready
/// Respects `visible` property
class Expression extends StatefulWidget {
  final FormElement el;
  final SurveyEngine engine;

  const Expression({Key? key, required this.el, required this.engine})
      : super(key: key);

  @override
  State<Expression> createState() => _ExpressionState();
}

class _ExpressionState extends State<Expression> {
  String displayValue = '';

  @override
  void initState() {
    super.initState();

    // Show initial value from formData
    final initial = widget.engine.getValue(widget.el.name);
    if (initial != null && initial.toString().isNotEmpty) {
      displayValue = initial.toString();
    }

    // Evaluate expression if exists
    _evaluateExpression();

    // Listen for engine changes
    widget.engine.addListener(_evaluateExpression);
  }

  @override
  void dispose() {
    widget.engine.removeListener(_evaluateExpression);
    super.dispose();
  }

  void _evaluateExpression() {
    String result = '';

    try {
      final expr = widget.el.expression;
      if (expr != null && expr.isNotEmpty) {
        String s = expr;

        // Replace {FIELD} with engine values
        final re = RegExp(r'\{([^}]+)\}');
        s = s.replaceAllMapped(re, (m) {
          final key = m[1]!;
          final value = widget.engine.values[key];
          return value != null ? value.toString() : '';
        });

        // Handle simple concatenation using '+'
        final parts = s.split('+').map((p) => p.trim()).toList();
        result = parts.join();
      }

      // Fallback to formData initial value if expression result empty
      if (result.isEmpty) {
        final initial = widget.engine.getValue(widget.el.name);
        if (initial != null) {
          result = initial.toString();
        }
      }

      // Update engine if value changed
      final current = widget.engine.values[widget.el.name]?.toString() ?? '';
      if (current != result) {
        widget.engine.setValue(widget.el.name, result);
      }
    } catch (e) {
      result = 'خطا در محاسبه';
    }

    if (mounted) {
      setState(() {
        displayValue = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Respect visibility: compute value in background but do not show
    if (!widget.engine.isVisible(widget.el)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(displayValue, textAlign: TextAlign.right),
        trailing: const Icon(Icons.calculate, color: Colors.blueGrey),
        onTap: null,
      ),
    );
  }
}
