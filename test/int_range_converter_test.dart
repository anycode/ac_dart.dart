import 'package:ac_dart/ac_dart.dart';
import 'package:ac_ranges/ac_ranges.dart';
import 'package:test/test.dart';

void main() {
  group('Test IntRangeConverter', () {
    test('Test IntRange conversion', () {
      const IntRangeConverter converter = IntRangeConverter();
      final range = IntRange(10, 20);

      expect(converter.fromJson('[10,20)'), equals(range));
      expect(converter.toJson(range), '[10,20)');
    });

    test('Test invalid string conversion', () {
      const IntRangeConverter converter = IntRangeConverter();

      expect(converter.fromJson('invalid_range'), equals(IntRange(0, 0)));
    });
  });

  group('Test IntRangesConverter', () {
    test('Test IntRange list conversion', () {
      const IntRangesConverter converter = IntRangesConverter();
      final ranges = [IntRange(10, 20), IntRange(30, 40)];

      expect(converter.fromJson(['[10,20)', '[30,40)']), equals(ranges));
      expect(converter.toJson(ranges), ['[10,20)', '[30,40)']);
    });

    test('Test list conversion with invalid strings', () {
      const IntRangesConverter converter = IntRangesConverter();

      expect(converter.fromJson(['[10,20)', 'invalid']),
             equals([IntRange(10, 20), IntRange(0, 0)]));
    });
  });
}
