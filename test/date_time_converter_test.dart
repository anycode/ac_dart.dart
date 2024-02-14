import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Test date converter', () {
    test('Test date conversion', () {
      const DateConverter converter = DateConverter();
      expect(converter.fromJson('2020-01-01'), DateTime(2020, 01, 01));
      expect(converter.toJson(DateTime(2020, 01, 01)), '2020-01-01');
    });

    test('Test date list conversion', () {
      const DateListConverter converter = DateListConverter();
      expect(converter.fromJson(['2020-01-01']), [DateTime(2020, 01, 01)]);
      expect(converter.toJson([DateTime(2020, 01, 01)]), ['2020-01-01']);
    });
  });

  group('Test datetime converter', () {
    test('Test datetime conversion (UTC)', () {
      const DateTimeConverter converter = DateTimeConverter.utc();
      expect(converter.fromJson('2020-01-01T00:00:00.000Z'), DateTime.utc(2020, 01, 01));
      expect(converter.toJson(DateTime.utc(2020, 01, 01)), '2020-01-01T00:00:00.000Z');
    });

    test('Test datetime conversion (Local time)', () {
      const DateTimeConverter converter = DateTimeConverter.local();
      expect(converter.fromJson('2020-01-01T00:00:00.000+01:00'), DateTime(2020, 01, 01));
      expect(converter.toJson(DateTime(2020, 01, 01)), '2020-01-01T00:00:00.000+01:00');
    });

    test('Test datetime list conversion (UTC)', () {
      const DateTimeListConverter converter = DateTimeListConverter.utc();
      expect(converter.fromJson(['2020-01-01T00:00:00.000Z']), [DateTime.utc(2020, 01, 01)]);
      expect(converter.toJson([DateTime.utc(2020, 01, 01)]), ['2020-01-01T00:00:00.000Z']);
    });

    test('Test datetime list conversion (Local time)', () {
      const DateTimeListConverter converter = DateTimeListConverter.local();
      expect(converter.fromJson(['2020-01-01T00:00:00.000+01:00']), [DateTime(2020, 01, 01)]);
      expect(converter.toJson([DateTime(2020, 01, 01)]), ['2020-01-01T00:00:00.000+01:00']);
    });

  });

  group('Test time converter', () {
    test('Test time conversion Hm', () {
      // seconds are ignored
      const TimeConverter converter = TimeConverter.hm();
      expect(converter.fromJson('12:34:56'), DateTime(1970, 1, 1, 12, 34, 00));
      expect(converter.toJson(DateTime(0, 0, 0, 12, 34, 56)), '12:34');
    });

    test('Test time conversion Hms', () {
      const TimeConverter converter = TimeConverter.hms();
      expect(converter.fromJson('12:34:56'), DateTime(1970, 1, 1, 12, 34, 56));
      expect(converter.toJson(DateTime(0, 0, 0, 12, 34, 56)), '12:34:56');
    });

    test('Test time list conversion Hm', () {
      // seconds are ignored
      const TimeListConverter converter = TimeListConverter.hm();
      expect(converter.fromJson(['12:34:56']), [DateTime(1970, 1, 1, 12, 34, 00)]);
      expect(converter.toJson([DateTime(0, 0, 0, 12, 34, 56)]), ['12:34']);
    });

    test('Test time list conversion Hms', () {
      const TimeListConverter converter = TimeListConverter.hms();
      expect(converter.fromJson(['12:34:56']), [DateTime(1970, 1, 1, 12, 34, 56)]);
      expect(converter.toJson([DateTime(0, 0, 0, 12, 34, 56)]), ['12:34:56']);
    });

  });
}
