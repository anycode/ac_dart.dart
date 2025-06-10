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
  group('Test QuarterConverter', () {
    test('Test string to quarter conversion', () {
      const QuarterConverter converter = QuarterConverter();

      // Q1 (January-March)
      expect(converter.fromJson('2020q1'), DateTime(2020, 1, 1));
      // Q2 (April-June)
      expect(converter.fromJson('2020q2'), DateTime(2020, 4, 1));
      // Q3 (July-September)
      expect(converter.fromJson('2020q3'), DateTime(2020, 7, 1));
      // Q4 (October-December)
      expect(converter.fromJson('2020q4'), DateTime(2020, 10, 1));
    });

    test('Test DateTime to quarter conversion', () {
      const QuarterConverter converter = QuarterConverter();

      // Any day in Q1 must be processed as the 1st day of Q1
      expect(converter.fromJson(DateTime(2020, 3, 15)), DateTime(2020, 1, 1));
      // Any day in Q3 must be processed as the 1st day of Q3
      expect(converter.fromJson(DateTime(2020, 9, 30)), DateTime(2020, 7, 1));
    });

    test('Test quarter to string conversion', () {
      const QuarterConverter converter = QuarterConverter();

      expect(converter.toJson(DateTime(2020, 1, 1)), '2020q1');
      expect(converter.toJson(DateTime(2020, 4, 1)), '2020q2');
      expect(converter.toJson(DateTime(2020, 7, 1)), '2020q3');
      expect(converter.toJson(DateTime(2020, 10, 1)), '2020q4');
    });

    test('Test error handling', () {
      const QuarterConverter converter = QuarterConverter();

      expect(() => converter.fromJson(123), throwsException);
    });
  });

  group('Test QuarterListConverter', () {
    test('Test quarters list conversion', () {
      const QuarterListConverter converter = QuarterListConverter();
      final quarters = [DateTime(2020, 1, 1), DateTime(2020, 4, 1), DateTime(2020, 7, 1)];
      final strings = ['2020q1', '2020q2', '2020q3'];

      expect(converter.fromJson(strings), equals(quarters));
      expect(converter.toJson(quarters), equals(strings));
    });
  });
}