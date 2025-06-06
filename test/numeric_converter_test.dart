import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Test NumericConverter', () {
    test('Test conversion of numeric value to double', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromPgSql(123), equals(123.0));
      expect(converter.fromPgSql(123.45), equals(123.45));
    });

    test('Test conversion of string to double', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromPgSql('123.45'), equals(123.45));
      expect(converter.fromPgSql('-123.45'), equals(-123.45));
    });

    test('Test conversion of invalid string', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromPgSql('neplatná_hodnota'), equals(0.0));
    });

    test('Test conversion of double to string', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.toPgSql(123.45), equals('123.45'));
      expect(converter.toPgSql(-123.45), equals('-123.45'));
    });

    test('Test error handling', () {
      const NumericConverter converter = NumericConverter();

      expect(() => converter.fromPgSql(true), throwsException);
    });
  });

  group('Test NumericListConverter', () {
    test('Test conversion of numeric values list', () {
      const NumericListConverter converter = NumericListConverter();
      final numbers = [123, 456.78, '789.01'];
      final doubles = [123.0, 456.78, 789.01];

      expect(converter.fromPgSql(numbers), equals(doubles));
    });

    test('Test conversion of double list to strings', () {
      const NumericListConverter converter = NumericListConverter();
      final doubles = [123.0, 456.78, -789.01];
      final strings = ['123.0', '456.78', '-789.01'];

      expect(converter.toPgSql(doubles), equals(strings));
    });
  });
}
