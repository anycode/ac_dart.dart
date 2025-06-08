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

import 'package:intl/intl.dart';

/// Helper class for formatting number
/// Allows full control over formatting of numbers
class FormatNumber {
  static final _cache = <int, FormatNumber>{};

  final NumberFormat _format;

  /// Holds an empty value to be displayed when formatted value is null, default ''
  final String emptyValue;

  /// Creates an object for formatting numbers
  /// Pass [decimalDigits] to specify number of decimal digits, default 2.
  /// [emptyValue] is an empty value to be displayed when formatted value is null, default ''
  /// Specify [locale] to specify locale, default `cs_CZ`. When [grouping] is false, grouping is turned off.
  factory FormatNumber({int decimalDigits = 2, String emptyValue = '', String locale = 'cs_CZ', bool grouping = true}) {
    return _cache.putIfAbsent(decimalDigits.hashCode ^ locale.hashCode ^ grouping.hashCode,
            () => FormatNumber._(decimalDigits, locale, grouping, emptyValue));
  }

  /// Private constructor
  FormatNumber._(int decimals, String locale, bool grouping, this.emptyValue)
      : _format = NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimals) {
    if(! grouping) {
      _format.turnOffGrouping();
    }
  }

  /// Formats passed [number] using [_format], if null is passed, [emptyValue] is returned.
  format(num? number) => number == null ? emptyValue : _format.format(number);

}

/// Global shorthand to `FormatNumber({int decimalDigits}).format(num? number)`
///
/// Formats a number as a String.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatNumber(4535.273, decimalDigits: 1) => '4535,3'
/// formatNumber(null) => ''
/// ```
String formatNumber(num? number, [int decimalDigits = 2]) => FormatNumber(decimalDigits: decimalDigits).format(number);

/// Global shorthand function to `FormatNumber({int decimalDigits, grouping: false}).format(num? number)`
///
/// Formats a number as a String to be used in CSV output. No grouping is applied so the output is suitable for
/// machine processing.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatCsvNumber(4535.238) => '4535,24'
/// formatCsvNumber(null) => ''
/// ```
String formatCsvNumber(num? number, [int decimalDigits = 2]) => FormatNumber(decimalDigits: decimalDigits, grouping: false).format(number);

/// Global shorthand function to `FormatNumber({int decimalDigits}).format(num? number)`. It's the same as [formatNumber].
///
/// Formats a number as a String to be used in table output.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatTableNumber(4535.283, decimalDigits: 1) => '4535,3'
/// formatTableNumber(null) => ''
/// ```
String formatTableNumber(num? number, [int decimalDigits = 2]) => FormatNumber(decimalDigits: decimalDigits).format(number);
