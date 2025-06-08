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
import 'package:ac_ranges/ac_ranges.dart';
import 'package:test/test.dart';

void main() {
  group('Test DateRangeConverter', () {
    test('Test DateRange conversion', () {
      const DateRangeConverter converter = DateRangeConverter();
      final from = DateTime(2020, 1, 1);
      final to = DateTime(2020, 12, 31);
      final range = DateRange(from, to);

      expect(converter.fromJson('[2020-01-01,2020-12-31)'), equals(range));
      expect(converter.toJson(range), '[2020-01-01,2020-12-31)');
    });

    test('Test infinite range conversion', () {
      const DateRangeConverter converter = DateRangeConverter();
      final infiniteRange = DateRange(null, null);

      expect(converter.fromJson('[-infinity,infinity)'), equals(infiniteRange));
      expect(converter.toJson(infiniteRange), '(-infinity,infinity)');
    });

    test('Test invalid string conversion', () {
      const DateRangeConverter converter = DateRangeConverter();

      expect(converter.fromJson('invalid_range'), equals(DateRange(null, null)));
    });

    test('Test PgSql methods', () {
      const DateRangeConverter converter = DateRangeConverter();
      final range = DateRange(DateTime(2020, 1, 1), DateTime(2020, 12, 31));
      final text = '[2020-01-01,2020-12-31)';

      expect(converter.fromPgSql(text), equals(range));
      expect(converter.toPgSql(range), text);
    });
  });

  group('Test DateRangesConverter', () {
    test('Test DateRange list conversion', () {
      const DateRangesConverter converter = DateRangesConverter();
      final ranges = [
        DateRange(DateTime(2020, 1, 1), DateTime(2020, 12, 31)),
        DateRange(DateTime(2021, 1, 1), DateTime(2021, 12, 31))
      ];

      expect(converter.fromJson(['[2020-01-01,2020-12-31)', '[2021-01-01,2021-12-31)']), equals(ranges));
      expect(converter.toJson(ranges), ['[2020-01-01,2020-12-31)', '[2021-01-01,2021-12-31)']);
    });

    test('Test PgSql methods', () {
      const DateRangesConverter converter = DateRangesConverter();
      final ranges = [
        DateRange(DateTime(2020, 1, 1), DateTime(2020, 12, 31)),
        DateRange(DateTime(2021, 1, 1), DateTime(2021, 12, 31))
      ];
      final texts = ['[2020-01-01,2020-12-31)', '[2021-01-01,2021-12-31)'];

      expect(converter.fromPgSql(texts), equals(ranges));
      expect(converter.toPgSql(ranges), texts);
    });
  });
}
