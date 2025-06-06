import 'package:ac_dart/ac_dart.dart';
import 'package:ac_ranges/ac_ranges.dart';
import 'package:test/test.dart';

void main() {
  group('Test DoubleRangeConverter', () {
    test('Test DoubleRange conversion', () {
      const DoubleRangeConverter converter = DoubleRangeConverter();
      final range = DoubleRange(10.5, 20.5);

      expect(converter.fromJson('[10.5,20.5)'), equals(range));
      expect(converter.toJson(range), '[10.5,20.5)');
    });

    test('Test invalid string conversion', () {
      const DoubleRangeConverter converter = DoubleRangeConverter();

      expect(converter.fromJson('invalid_range'), equals(DoubleRange(0.0, 0.0)));
    });
  });

  group('Test DoubleRangesConverter', () {
    test('Test DoubleRange list conversion', () {
      const DoubleRangesConverter converter = DoubleRangesConverter();
      final ranges = [DoubleRange(10.5, 20.5), DoubleRange(30.5, 40.5)];

      expect(converter.fromJson(['[10.5,20.5)', '[30.5,40.5)']), equals(ranges));
      expect(converter.toJson(ranges), ['[10.5,20.5)', '[30.5,40.5)']);
    });

    test('Test list conversion with invalid strings', () {
      const DoubleRangesConverter converter = DoubleRangesConverter();

      expect(converter.fromJson(['[10.5,20.5)', 'invalid']),
             equals([DoubleRange(10.5, 20.5), DoubleRange(0.0, 0.0)]));
    });
  });
}
