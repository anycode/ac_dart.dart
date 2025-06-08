/*
 * Copyright 2025 Martin Edlman - Anycode <ac@anycode.dev>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:ac_dart/ac_dart.dart';
import 'package:test/test.dart';

void main() {
  group('Test formatting', () {
    test('Test formatting number', () {
      expect(formatNumber(7845745.2384), '7 845 745,24');
      expect(7845745.2384.format(), '7 845 745,24');
      expect(formatCsvNumber(76435.356), '76435,36');
      expect(76435.356.formatCsv(), '76435,36');
      expect(formatTableNumber(-85756.37235), '-85 756,37');
      expect((-85756.37235).formatTable(), '-85 756,37');
      expect(formatTableNumber(0.3), '0,30');
      expect(0.3.formatTable(), '0,30');
      expect(formatNumber(7845745.2384), '7 845 745,24');
      expect(7845745.2384.format(), '7 845 745,24');
      expect(formatTableNumber(null), '');
    });

    test('Test formatting price', () {
      expect(formatPrice(7845745.2384), '7 845 745,24 Kč');
      expect(7845745.2384.formatPrice(), '7 845 745,24 Kč');
      expect(formatCsvPrice(3446.237235), '3446,24');
      expect(3446.237235.formatCsv(), '3446,24');
      expect(formatTablePrice(-989.94), '-989,94');
      expect((-989.94).formatTable(), '-989,94');
      expect(formatCsvPrice(null), '');
    });

    test('Test formatting distance', () {
      expect(formatDistance(7845745.2384), '7 845 745,24 m');
      expect(7845745.2384.formatDistance(), '7 845 745,24 m');
      expect(formatDistance(7845745.2384, modulo: 1000, unit: 'km'), '7 845,75 km');
      expect(7845745.2384.formatDistance(unit: 'km'), '7 845,75 km');
      expect(formatCsvDistance(3446.237235, decimalDigits: 3), '3446,237');
      expect(3446.237235.formatCsv(3), '3446,237');
      expect(formatTableDistance(-989.94), '-989,94');
      expect((-989.94).formatTable(), '-989,94');
      expect(formatCsvDistance(null), '');
      expect(formatTableDistance(null), '');
    });

    test('Test formatting geo', () {
      expect(formatLatitude(245.23844354), '245°14\'18.397"N');
      expect(245.23844354.formatLatitudeDMS(), '245°14\'18.397"N');
      expect(245.23844354.formatLatitudeDM(), '245°14.3066\'N');
      expect(245.23844354.formatLatitudeD(), '245.238444°N');
      expect(formatLatitude(-143.3845908940), '143°23\'4.527"S');
      expect((-143.3845908940).formatLatitudeDMS(), '143°23\'4.527"S');
      expect(formatLongitude(143.3845908940), '143°23\'4.527"E');
      expect(143.3845908940.formatLongitudeDMS(), '143°23\'4.527"E');
      expect(143.3845908940.formatLongitudeDM(), '143°23.0755\'E');
      expect(143.3845908940.formatLongitudeD(), '143.384591°E');
      expect(formatLongitude(-23.8792347898), '23°52\'45.245"W');
      expect((-23.8792347898).formatLongitudeDMS(), '23°52\'45.245"W');
    });
  });
}
