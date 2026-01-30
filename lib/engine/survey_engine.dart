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

    bool changed = false;
    initial.forEach((key, value) {
      if (values[key] != value) {
        values[key] = value;
        changed = true;
      }
    });

    if (changed) {
      _evaluateCalculatedValues();
      notifyListeners();
    }
  }

  dynamic getValue(String key) => values[key];

  // ---------------- SET VALUE ----------------

  Future<void> setValue(String key, dynamic value) async {
    final old = values[key];
    if (old == value) return; // ⛔ prevents infinite loop

    values[key] = value;

    onValueChanged?.call(key, value);

    await _evaluateCalculatedValues();

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

    //  Clear value if invisible
    if (!res && el.clearIfInvisible != 'none') {
      values.remove(el.name);
    }

    return res;
  }

  // ---------------- CALCULATED VALUES ----------------

  Future<void> _evaluateCalculatedValues() async {
    bool changed = false;

    for (final page in schema.pages) {
      for (final el in page.elements) {
        if (el.calculatedValue == null || el.calculatedValue!.trim().isEmpty)
          continue;

        final newVal = evaluator.evaluate(el.calculatedValue!, values);

        final oldVal = values[el.name];

        if (newVal != oldVal) {
          values[el.name] = newVal;
          changed = true;
        }
      }
    }

    if (changed) {
      notifyListeners();
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
