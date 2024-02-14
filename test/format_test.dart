import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Test formatting', () {
    test('Test formatting number', () {
      expect(formatNumber(7845745.2384), '7 845 745,24');
      expect(formatCsvNumber(76435.356), '76435,36');
      expect(formatTableNumber(-85756.37235), '-85 756,37');
      expect(formatTableNumber(0.3), '0,30');
      expect(formatTableNumber(null), '');
      expect(formatNumber(7845745.2384), '7 845 745,24');
    });

    test('Test formatting price', () {
      expect(formatPrice(7845745.2384), '7 845 745,24 Kč');
      expect(formatCsvPrice(3446.237235), '3446,24');
      expect(formatCsvPrice(null), '');
      expect(formatTablePrice(-989.94), '-989,94');
    });

    test('Test formatting distance', () {
      expect(formatDistance(7845745.2384), '7 845 745,24 m');
      expect(formatDistance(7845745.2384, modulo: 1000, unit: 'km'), '7 845,75 km');
      expect(formatCsvDistance(3446.237235, decimalDigits: 3), '3446,237');
      expect(formatCsvDistance(null), '');
      expect(formatTableDistance(-989.94), '-989,94');
    });

    test('Test formatting geo', () {
      expect(formatLatitude(245.23844354), '245°14\'18.397"N');
      expect(formatLatitude(-143.3845908940), '143°23\'4.527"S');
      expect(formatLongitude(143.3845908940), '143°23\'4.527"E');
      expect(formatLongitude(-23.8792347898), '23°52\'45.245"W');
    });
  });
}
