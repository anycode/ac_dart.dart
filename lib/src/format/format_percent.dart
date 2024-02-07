import 'package:intl/intl.dart';

class FormatPercent {
  static final _cache = <int, FormatPercent>{};

  final NumberFormat _format;

  /// Holds an empty value to be displayed when formatted value is null, default ''
  final String emptyValue;

  /// Creates an object for formatting percent
  /// Pass [decimalDigits] to specify number of decimal digits, default 2. [emptyValue] is an empty value to be
  /// displayed when formatted value is null, default ''. Specify [locale] to specify locale, default `cs_CZ`.
  factory FormatPercent({int decimalDigits = 2, String emptyValue = '', String locale = 'cs_CZ', bool grouping = true}) {
    return _cache.putIfAbsent(
        decimalDigits.hashCode ^ emptyValue.hashCode ^ locale.hashCode, () => FormatPercent._(decimalDigits, locale, grouping, emptyValue));
  }

  FormatPercent._(int decimalDigits, String locale, bool grouping, this.emptyValue)
      : _format = NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimalDigits) {
    if (!grouping) {
      _format.turnOffGrouping();
    }
  }

  /// Formats passed [number] using [_format], if null is passed, [emptyValue] is returned.
  format(num? number) => number == null ? emptyValue : _format.format(number);
}

/// Global shorthand to `FormatPercent({int decimalDigits}).format(num? number)`
///
/// Formats a number as a String.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatPercent(4535.273, decimalDigits: 1) => '4535,3'
/// formatPercent(null) => ''
/// ```
String formatPercent(num? number, [int decimalDigits = 2]) => FormatPercent(decimalDigits: decimalDigits).format(number);

/// Global shorthand function to `FormatPercent({int decimalDigits, grouping: false}).format(num? number)`
///
/// Formats a number as a String to be used in CSV output. No grouping is applied so the output is suitable for
/// machine processing.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatCsvPercent(4535.238) => '4535,24'
/// formatCsvPercent(null) => ''
/// ```
String formatCsvPercent(num? number, [int decimalDigits = 2]) => FormatPercent(
      decimalDigits: decimalDigits,
      grouping: false,
    ).format(number);

/// Global shorthand function to `FormatPercent({int decimalDigits}).format(num? number)`. It's same as [formatPercent].
///
/// Formats a number as a String to be used in table output. No currency symbol is used so the output is suitable
/// for tables.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatTableNumber(4535.283, decimalDigits: 1) => '4535,3'
/// formatTableNumber(null) => ''
/// ```
String formatTablePercent(num? number, [int decimalDigits = 2]) => FormatPercent(decimalDigits: decimalDigits).format(number);
