import 'dart:convert';

import 'package:ac_dart/ac_dart.dart';
import 'package:latlong2/latlong.dart';
import 'package:test/test.dart';

void main() {
  group('Core extensions', () {
    test('asOrNull test', () {
      expect(1.asOrNull<int>(), 1);
      expect(1.23.asOrNull<double>(), 1.23);
      expect(1.23.asOrNull<num>(), 1.23);
      expect("string".asOrNull<int>(), null);
    });
  });

  group('DateTime extensions', () {
    test('quarter tests', () {
      DateTime dateTime = DateTime(2020, 01, 01, 12, 34, 56, 789);
      expect(dateTime.quarter, 1);
    });
    test('withDate tests', () {
      DateTime dateTime = DateTime(2020, 01, 01, 12, 34, 56, 789);
      expect(dateTime.withDate(DateTime(2022, 02, 03)), DateTime(2022, 02, 03, 12, 34, 56, 789));
    });
    test('withTime tests', () {
      DateTime dateTime = DateTime(2020, 01, 01, 12, 34, 56, 789);
      expect(dateTime.withTime(DateTime(2022, 02, 03, 23, 59, 59, 999)), DateTime(2020, 01, 01, 23, 59, 59, 999));
    });
    test('toIso8601StringTZD tests', () {
      // local datetime
      DateTime dateTime = DateTime(2020, 01, 01, 12, 34, 56, 789);
      expect(dateTime.toIso8601String(), '2020-01-01T12:34:56.789');
      expect(dateTime.toIso8601StringTZD(), '2020-01-01T12:34:56.789+01:00');
      // UTC datetime
      dateTime = DateTime.utc(2020, 01, 01, 12, 34, 56, 789);
      expect(dateTime.toIso8601String(), '2020-01-01T12:34:56.789Z');
      expect(dateTime.toIso8601StringTZD(), '2020-01-01T12:34:56.789Z');
    });
  });

  group('JsonCodec extensions', () {
    test('decodeBytes test', () {
      final data = <String, String>{'key': 'Žluťoučký kůň úpěl ďábelské ódy'};
      final str = jsonEncode(data);
      final bytes = utf8.encode(str);
      expect(json.decodeBytes(bytes), data);
    });
  });

  group('Kotlin extensions', () {
    test('takeIf test', () {
      expect(1.takeIf((value) => value == 1), 1);
      expect(1.takeIf((value) => value == 2), null);
      expect(null.takeIf((value) => value == 2), null);
      var x = 1;
      expect(x.takeIf((value) => value == 1), 1);
      expect(x.takeIf((value) => value == 2), null);
      for(var i = 0; i < 10; i++) {
        expect(i.takeIf((value) => value < 5), i < 5 ? i : null);
      }
    });
  });

  group('LatLng extensions', () {
    test('parse test', () {
      print('\u00B0');
      expect(LatLngExt.parse('50.763849890N 16.3423545E')!.round(), LatLng(50.763849890, 16.3423545).round());
      expect(LatLngExt.parse('50deg 30min 5.64324sec N, 16deg 12.3456min E')!.round(), LatLng(50.501568, 16.20576).round());
      expect(LatLngExt.parse('50° 30\' 5.65434" N, 16°12\'8.2324235"E')!.round(), LatLng(50.501571, 16.202287).round());
      expect(LatLngExt.parse(null), null);
    });
  });

}
