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
  group('Test NumericConverter', () {
    test('Test conversion of numeric value to double', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromJson(123), equals(123.0));
      expect(converter.fromJson(123.45), equals(123.45));
    });

    test('Test conversion of string to double', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromJson('123.45'), equals(123.45));
      expect(converter.fromJson('-123.45'), equals(-123.45));
    });

    test('Test conversion of invalid string', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.fromJson('neplatná_hodnota'), equals(0.0));
    });

    test('Test conversion of double to string', () {
      const NumericConverter converter = NumericConverter();

      expect(converter.toJson(123.45), equals('123.45'));
      expect(converter.toJson(-123.45), equals('-123.45'));
    });

    test('Test error handling', () {
      const NumericConverter converter = NumericConverter();

      expect(() => converter.fromJson(true), throwsException);
    });
  });

  group('Test NumericListConverter', () {
    test('Test conversion of numeric values list', () {
      const NumericListConverter converter = NumericListConverter();
      final numbers = [123, 456.78, '789.01'];
      final doubles = [123.0, 456.78, 789.01];

      expect(converter.fromJson(numbers), equals(doubles));
    });

    test('Test conversion of double list to strings', () {
      const NumericListConverter converter = NumericListConverter();
      final doubles = [123.0, 456.78, -789.01];
      final strings = ['123.0', '456.78', '-789.01'];

      expect(converter.toJson(doubles), equals(strings));
    });
  });
}
