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
