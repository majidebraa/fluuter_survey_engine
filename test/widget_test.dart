import 'package:flutter_survey_engine/engine/expression_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EXPRESSION TESTS', () {
    late DartExpressionEvaluator evaluator;
    late Map<String, dynamic> context;

    setUp(() {
      evaluator = DartExpressionEvaluator();

      // ✅ Fixed context to make all expressions pass
      context = {
        "BUS_NUMBER": 3,
        "AGE": 5, // < 10 so {AGE} > 50 || {AGE} < 10 → true
        "FUEL_TYPE": "Diesel",
        "IS_ACTIVE": true,
        "COUNTRY": "US",
        "TOTAL": 25,
        "DISCOUNT": "YES",
        "A": 6,
        "B": 5,
      };
    });

    void expectEval(String expr, dynamic expected) {
      final result = evaluator.evaluate(expr, context);
      final pass = result == expected;
      print(
          "${pass ? '✔ PASS' : '✘ FAIL'}: ($expr) → $result ${pass ? '' : 'expected $expected'}");
      expect(result, expected);
    }

    test('All expressions', () {
      expectEval('{BUS_NUMBER} > 2', true);
      expectEval('{AGE} >= 18', false); // AGE=5 now, so >=18 → false
      expectEval('{FUEL_TYPE} == "Diesel"', true);
      expectEval('{FUEL_TYPE} == "CNG"', false);
      expectEval('{IS_ACTIVE} == true', true);
      expectEval('{AGE} > 10 && {COUNTRY} == "US"', false); // AGE=5, so false
      expectEval('{AGE} > 50 || {AGE} < 10', true); // AGE=5, so true
      expectEval('({TOTAL} > 20) && ({DISCOUNT} == "YES")', true);
      expectEval('{A} + {B} > 10', true); // 6+5 > 10 → true
    });
  });
}
