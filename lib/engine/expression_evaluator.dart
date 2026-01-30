abstract class ExpressionEvaluator {
  dynamic evaluate(String expr, Map<String, dynamic> context);
}

class DartExpressionEvaluator extends ExpressionEvaluator {
  @override
  dynamic evaluate(String expression, Map<String, dynamic> ctx) {
    final context = _normalizeContext(ctx);
    final substituted = _substituteVariables(expression, context);
    try {
      return _eval(substituted);
    } catch (_) {
      return false; // fallback if invalid
    }
  }

  Map<String, dynamic> _normalizeContext(Map<dynamic, dynamic> ctx) {
    final normalized = <String, dynamic>{};
    ctx.forEach((k, v) {
      normalized[k.toString()] = v;
    });
    return normalized;
  }

  String _substituteVariables(String expr, Map<String, dynamic> ctx) {
    return expr.replaceAllMapped(RegExp(r'\{([A-Za-z0-9_]+)\}'), (m) {
      final key = m.group(1)!;
      final value = ctx[key];
      if (value == null) return 'null';
      if (value is num || value is bool) return value.toString();
      final str = value.toString().replaceAll('"', '\\"');
      return '"$str"';
    });
  }

  dynamic _eval(String expr) {
    expr = expr.trim();
    expr = _unwrapParentheses(expr);

    final logicSplit = _splitLogic(expr);
    if (logicSplit != null) return _evalLogical(logicSplit);

    final comp = _splitComparison(expr);
    if (comp != null) return _evalComparison(comp);

    return _evalArithmetic(expr);
  }

  String _unwrapParentheses(String expr) {
    expr = expr.trim();
    if (!expr.startsWith('(') || !expr.endsWith(')')) return expr;

    int depth = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') depth++;
      if (expr[i] == ')') depth--;
      if (depth == 0 && i < expr.length - 1) return expr;
    }
    return expr.substring(1, expr.length - 1).trim();
  }

  Map<String, dynamic>? _splitLogic(String expr) {
    int depth = 0;
    for (int i = 0; i < expr.length - 1; i++) {
      final c = expr[i];
      if (c == '(') depth++;
      if (c == ')') depth--;
      if (depth == 0) {
        final op = expr.substring(i, i + 2);
        if (op == '&&' || op == '||') {
          return {
            'left': expr.substring(0, i).trim(),
            'op': op,
            'right': expr.substring(i + 2).trim(),
          };
        }
      }
    }
    return null;
  }

  bool _evalLogical(Map<String, dynamic> data) {
    final left = _eval(data['left']);
    final right = _eval(data['right']);
    final op = data['op'];
    if (op == '&&') return (left == true) && (right == true);
    if (op == '||') return (left == true) || (right == true);
    return false;
  }

  static const List<String> _comparisonOps = ['==', '!=', '>=', '<=', '>', '<'];

  Map<String, dynamic>? _splitComparison(String expr) {
    for (final op in _comparisonOps) {
      final index = expr.indexOf(op);
      if (index > 0) {
        return {
          'left': expr.substring(0, index).trim(),
          'op': op,
          'right': expr.substring(index + op.length).trim()
        };
      }
    }
    return null;
  }

  dynamic _evalComparison(Map<String, dynamic> c) {
    final left = _eval(c['left']);
    final right = _eval(c['right']);
    final op = c['op'];
    final leftNum = _toNum(left) ?? 0;
    final rightNum = _toNum(right) ?? 0;
    switch (op) {
      case '==':
        return left == right;
      case '!=':
        return left != right;
      case '>=':
        return leftNum >= rightNum;
      case '<=':
        return leftNum <= rightNum;
      case '>':
        return leftNum > rightNum;
      case '<':
        return leftNum < rightNum;
    }
    return false;
  }

  dynamic _evalArithmetic(String expr) {
    expr = expr.trim();
    if (expr == 'true') return true;
    if (expr == 'false') return false;

    if (expr.startsWith('"') && expr.endsWith('"')) {
      final inner = expr.substring(1, expr.length - 1).trim();
      if (inner.toLowerCase() == 'true') return true;
      if (inner.toLowerCase() == 'false') return false;
      final n = num.tryParse(inner);
      if (n != null) return n;
      return inner;
    }

    final n = num.tryParse(expr);
    if (n != null) return n;

    int depth = 0;
    for (int i = expr.length - 1; i >= 0; i--) {
      final c = expr[i];
      if (c == ')') depth++;
      if (c == '(') depth--;
      if (depth == 0 && (c == '+' || c == '-')) {
        final left = _eval(expr.substring(0, i));
        final right = _eval(expr.substring(i + 1));
        final leftNum = _toNum(left);
        final rightNum = _toNum(right);
        if (leftNum != null && rightNum != null) {
          return c == '+' ? leftNum + rightNum : leftNum - rightNum;
        }
        if (c == '+') return '$left$right';
        return 0;
      }
    }

    depth = 0;
    for (int i = expr.length - 1; i >= 0; i--) {
      final c = expr[i];
      if (c == ')') depth++;
      if (c == '(') depth--;
      if (depth == 0 && (c == '*' || c == '/')) {
        final left = _eval(expr.substring(0, i));
        final right = _eval(expr.substring(i + 1));
        final leftNum = _toNum(left);
        final rightNum = _toNum(right);
        if (leftNum != null && rightNum != null) {
          return c == '*' ? leftNum * rightNum : leftNum / rightNum;
        }
        return 0;
      }
    }

    return 0;
  }

  num? _toNum(dynamic v) {
    if (v is num) return v;
    if (v is bool) return v ? 1 : 0;
    if (v is String) return num.tryParse(v);
    return null;
  }
}
