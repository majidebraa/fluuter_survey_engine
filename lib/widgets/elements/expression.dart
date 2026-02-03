import 'package:flutter/material.dart';
import '../../common/app_colors.dart';
import '../../engine/survey_engine.dart';
import '../../models/form_models.dart';

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
    _evaluateExpression(); // initial calculation
    widget.engine.addListener(_onEngineChanged);
  }

  @override
  void dispose() {
    widget.engine.removeListener(_onEngineChanged);
    super.dispose();
  }

  void _onEngineChanged() {
    _evaluateExpression();
  }

  void _evaluateExpression() {
    if (!mounted) return;

    String result = '';

    try {
      final expr = widget.el.expression;
      if (expr != null && expr.isNotEmpty) {
        var s = expr;

        // Replace {FIELD} with engine values
        final re = RegExp(r'\{([^}]+)\}');
        s = s.replaceAllMapped(re, (m) {
          final key = m[1]!;
          final value = widget.engine.getValue(key);
          return value != null ? value.toString() : '';
        });

        // Basic concatenation (optional)
        final parts = s.split('+').map((p) => p.trim()).toList();
        result = parts.join();
      }

      // Fallback to existing engine value if empty
      if (result.isEmpty) {
        final v = widget.engine.getValue(widget.el.name);
        if (v != null) result = v.toString();
      }

      // Update engine value if changed
      final current = widget.engine.getValue(widget.el.name)?.toString() ?? '';
      if (current != result) {
        widget.engine.setValue(widget.el.name, result);
      }
    } catch (_) {
      result = 'خطا در محاسبه';
    }

    setState(() {
      displayValue = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Respect visibility
    if (!widget.engine.isVisible(widget.el)) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(displayValue, textAlign: TextAlign.right),
        trailing: const Icon(Icons.calculate, color: AppColors.primaryColor),
      ),
    );
  }
}
