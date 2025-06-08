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
