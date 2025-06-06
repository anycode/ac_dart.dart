import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Test QuarterConverter', () {
    test('Test string to quarter conversion', () {
      const QuarterConverter converter = QuarterConverter();

      // Q1 (January-March)
      expect(converter.fromJson('2020q1'), DateTime(2020, 1, 1));
      // Q2 (April-June)
      expect(converter.fromJson('2020q2'), DateTime(2020, 4, 1));
      // Q3 (July-September)
      expect(converter.fromJson('2020q3'), DateTime(2020, 7, 1));
      // Q4 (October-December)
      expect(converter.fromJson('2020q4'), DateTime(2020, 10, 1));
    });

    test('Test DateTime to quarter conversion', () {
      const QuarterConverter converter = QuarterConverter();

      // Any day in Q1 must be processed as the 1st day of Q1
      expect(converter.fromJson(DateTime(2020, 3, 15)), DateTime(2020, 1, 1));
      // Any day in Q3 must be processed as the 1st day of Q3
      expect(converter.fromJson(DateTime(2020, 9, 30)), DateTime(2020, 7, 1));
    });

    test('Test quarter to string conversion', () {
      const QuarterConverter converter = QuarterConverter();

      expect(converter.toJson(DateTime(2020, 1, 1)), '2020q1');
      expect(converter.toJson(DateTime(2020, 4, 1)), '2020q2');
      expect(converter.toJson(DateTime(2020, 7, 1)), '2020q3');
      expect(converter.toJson(DateTime(2020, 10, 1)), '2020q4');
    });

    test('Test PgSql methods', () {
      const QuarterConverter converter = QuarterConverter();
      final q1 = DateTime(2020, 1, 1);

      expect(converter.fromPgSql('2020q1'), equals(q1));
      expect(converter.toPgSql(q1), '2020-01-01T00:00:00.000');
    });

    test('Test error handling', () {
      const QuarterConverter converter = QuarterConverter();

      expect(() => converter.fromJson(123), throwsException);
    });
  });

  group('Test QuarterListConverter', () {
    test('Test quarters list conversion', () {
      const QuarterListConverter converter = QuarterListConverter();
      final quarters = [DateTime(2020, 1, 1), DateTime(2020, 4, 1), DateTime(2020, 7, 1)];
      final strings = ['2020q1', '2020q2', '2020q3'];

      expect(converter.fromJson(strings), equals(quarters));
      expect(converter.toJson(quarters), equals(strings));
    });

    test('Test PgSql methods', () {
      const QuarterListConverter converter = QuarterListConverter();
      final quarters = [DateTime(2020, 1, 1), DateTime(2020, 4, 1)];
      final pgInputs = ['2020q1', '2020q2'];
      final pgOutputs = ['2020-01-01T00:00:00.000', '2020-04-01T00:00:00.000'];

      expect(converter.fromPgSql(pgInputs), equals(quarters));
      expect(converter.toPgSql(quarters), equals(pgOutputs));
    });
  });
}