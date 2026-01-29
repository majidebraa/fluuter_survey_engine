/// Abstract evaluator
abstract class ExpressionEvaluator {
  dynamic evaluate(String expr, Map<String, dynamic> context);
}

/// Simple evaluator for math, comparison, logical, and conditional
class DartSafeEvaluator implements ExpressionEvaluator {
  @override
  dynamic evaluate(String expr, Map<String, dynamic> context) {
    try {
      String s = expr;

      // Replace {FIELD}
      final reg = RegExp(r'\{([^}]+)\}');
      s = s.replaceAllMapped(reg, (m) {
        final v = context[m[1]];
        if (v == null) return 'null';
        if (v is num) return v.toString();
        return '"$v"';
      });

      // numeric comparisons
      bool evalCompare(String op) {
        final parts = s.split(op);
        final l = num.tryParse(parts[0].trim());
        final r = num.tryParse(parts[1].trim());
        if (l == null || r == null) return false;
        switch (op) {
          case '>':
            return l > r;
          case '<':
            return l < r;
          case '>=':
            return l >= r;
          case '<=':
            return l <= r;
        }
        return false;
      }

      if (s.contains('>=')) return evalCompare('>=');
      if (s.contains('<=')) return evalCompare('<=');
      if (s.contains('>')) return evalCompare('>');
      if (s.contains('<')) return evalCompare('<');

      if (s.contains('==')) {
        final p = s.split('==');
        return p[0].trim() == p[1].trim();
      }

      if (s.contains('!=')) {
        final p = s.split('!=');
        return p[0].trim() != p[1].trim();
      }

      if (s.contains('&&')) {
        return s.split('&&').every((e) => evaluate(e.trim(), context) == true);
      }

      if (s.contains('||')) {
        return s.split('||').any((e) => evaluate(e.trim(), context) == true);
      }

      return s;
    } catch (_) {
      return false;
    }
  }
}
