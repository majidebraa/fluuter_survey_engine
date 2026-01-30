import 'package:flutter/foundation.dart';

import '../models/form_models.dart';
import 'expression_evaluator.dart';

typedef ValueChangedCallback = void Function(String key, dynamic value);
typedef ValidationCallback = void Function(Map<String, String?> errors);

class SurveyEngine with ChangeNotifier {
  final FormSchema schema;
  final ExpressionEvaluator evaluator;

  final Map<String, dynamic> values = {};
  final Map<String, String?> errors = {};

  bool globalReadOnly = false;

  ValueChangedCallback? onValueChanged;
  ValidationCallback? onValidation;

  SurveyEngine(this.schema, {ExpressionEvaluator? evaluator})
      : evaluator = evaluator ?? DartExpressionEvaluator();

  // ---------------- INITIAL VALUES ----------------

  void setInitial(Map<String, dynamic>? initial) {
    if (initial == null) return;

    values.addAll(initial);
    evaluateAllExpressions();
    notifyListeners();
  }

  dynamic getValue(String key) => values[key];

  // ---------------- SET VALUE ----------------

  Future<void> setValue(String key, dynamic value) async {
    final old = values[key];
    if (old == value) return;

    values[key] = value;
    onValueChanged?.call(key, value);

    await evaluateAllExpressions();
    notifyListeners();
  }

  // ---------------- READONLY ----------------

  bool isReadOnly(FormElement el) {
    if (globalReadOnly) return true;
    return el.readOnly == true;
  }

  // ---------------- VISIBILITY ----------------

  bool isVisible(FormElement el) {
    if (el.visibleIf == null || el.visibleIf!.isEmpty) return true;

    final res = evaluator.evaluate(el.visibleIf!, values) == true;

    // Clear value if invisible
    if (!res && el.clearIfInvisible != 'none') {
      values.remove(el.name);
    }

    return res;
  }

  // ---------------- CALCULATED EXPRESSIONS ----------------

  /// Evaluate all calculated values and expressions for all elements
  Future<void> evaluateAllExpressions() async {
    bool changed = false;

    for (final page in schema.pages) {
      for (final el in page.elements) {
        // 1️⃣ Evaluate expression
        if (el.expression != null && el.expression!.trim().isNotEmpty) {
          final expr = el.expression!;
          String s = expr.replaceAllMapped(RegExp(r'\{([^}]+)\}'), (m) {
            final key = m[1]!;
            final value = values[key];
            return value != null ? value.toString() : '';
          });

          // Handle simple concatenation using '+'
          final parts = s.split('+').map((p) => p.trim()).toList();
          final result = parts.join();

          if (values[el.name]?.toString() != result) {
            values[el.name] = result;
            changed = true;
          }
        }

        // 2️⃣ Evaluate calculatedValue
        if (el.calculatedValue != null &&
            el.calculatedValue!.trim().isNotEmpty) {
          final newVal = evaluator.evaluate(el.calculatedValue!, values);
          if (values[el.name] != newVal) {
            values[el.name] = newVal;
            changed = true;
          }
        }

        // 3️⃣ Recursively evaluate child elements for panels
        if (el.type == 'panel' && el.elements != null) {
          for (final child in el.elements!) {
            await _evaluateElementExpressions(child);
          }
        }
      }
    }

    if (changed) notifyListeners();
  }

  Future<void> _evaluateElementExpressions(FormElement el) async {
    if (el.expression != null && el.expression!.trim().isNotEmpty) {
      final expr = el.expression!;
      String s = expr.replaceAllMapped(RegExp(r'\{([^}]+)\}'), (m) {
        final key = m[1]!;
        final value = values[key];
        return value != null ? value.toString() : '';
      });

      final parts = s.split('+').map((p) => p.trim()).toList();
      final result = parts.join();

      if (values[el.name]?.toString() != result) {
        values[el.name] = result;
      }
    }

    if (el.calculatedValue != null && el.calculatedValue!.trim().isNotEmpty) {
      final newVal = evaluator.evaluate(el.calculatedValue!, values);
      if (values[el.name] != newVal) {
        values[el.name] = newVal;
      }
    }

    if (el.type == 'panel' && el.elements != null) {
      for (final child in el.elements!) {
        await _evaluateElementExpressions(child);
      }
    }
  }

  // ---------------- VALIDATION ----------------

  Future<bool> validate() async {
    errors.clear();

    for (final page in schema.pages) {
      for (final el in page.elements) {
        _validateElement(el);
      }
    }

    onValidation?.call(errors);
    notifyListeners();

    return errors.values.every((e) => e == null);
  }

  void _validateElement(FormElement el) {
    if (!isVisible(el)) return;

    if (el.type == 'panel' && el.elements != null) {
      for (final child in el.elements!) {
        _validateElement(child);
      }
      return;
    }

    if (el.isRequired == true) {
      final v = values[el.name];
      if (v == null || (v is String && v.trim().isEmpty)) {
        errors[el.name] = '${el.title ?? el.name} is required';
      } else {
        errors[el.name] = null;
      }
    }
  }

  // ---------------- SUBMIT ----------------

  Future<bool> trySubmit() async {
    return await validate();
  }
}
