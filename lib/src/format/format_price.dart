import 'package:intl/intl.dart';

/// Helper class for formatting price
/// Allows full control over formatting of prices
class FormatPrice {
  static final _cache = <int, FormatPrice>{};

  final NumberFormat _format;

  /// Holds an empty value to be displayed when formatted value is null, default ''
  final String emptyValue;

  /// Creates an object for formatting prices
  /// Pass [decimalDigits] to specify number of decimal digits, default 2. Specify [symbol] to specify currency symbol,
  /// default 'Kč'. [emptyValue] is an empty value to be displayed when formatted value is null, default ''.
  /// Specify [locale] to specify locale, default `cs_CZ`. When [grouping] is false, grouping is turned off.
  factory FormatPrice(
      {int decimalDigits = 2, String symbol = 'Kč', String emptyValue = '', String locale = 'cs_CZ', bool grouping = true}) {
    return _cache.putIfAbsent(decimalDigits.hashCode ^ symbol.hashCode ^ locale.hashCode ^ grouping.hashCode,
        () => FormatPrice._(decimalDigits, locale, symbol, grouping, emptyValue));
  }

  /// Private constructor
  FormatPrice._(int decimals, String locale, String symbol, bool grouping, this.emptyValue)
      : _format = symbol == ''
        ? NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimals)
        : NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: decimals) {
    if (! grouping) {
      _format.turnOffGrouping();
    }
  }

  /// Formats passed [number] using [_format], if null is passed, [emptyValue] is returned.
  format(num? number) => number == null ? emptyValue : _format.format(number);
}

/// Global shorthand to `FormatPrice({int decimalDigits}).format(num? number)`
///
/// Formats a number as a String.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// FormatPrice(4535.273, decimalDigits: 1) => '4535,3'
/// FormatPrice(null) => ''
/// ```
String formatPrice(num? number, [int decimalDigits = 2]) => FormatPrice(decimalDigits: decimalDigits).format(number);

/// Global shorthand function to `FormatPrice({int decimalDigits, grouping: false, symbol: ''}).format(num? number)`
///
/// Formats a number as a String to be used in CSV output. No grouping is applied and no symbol is used so the output
/// is suitable for machine processing.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatCsvPrice(4535.238) => '4535,24'
/// formatCsvPrice(null) => ''
/// ```
String formatCsvPrice(num? number, [int decimalDigits = 2]) => FormatPrice(
      decimalDigits: decimalDigits,
      symbol: '',
      grouping: false,
    ).format(number);

/// Global shorthand function to `FormatPrice({int decimalDigits, currency: ''}).format(num? number)`.
///
/// Formats a number as a String to be used in table output. No currency symbol is used so the output is suitable
/// for tables where currency symbol is displayed in a header.
/// When [number] is null, empty string is returned, optional [decimalDigits] parameter can be used to specify number
/// of decimal digits, default 2.
/// ```dart
/// formatTablePrice(4535.283, decimalDigits: 1) => '4535,3'
/// formatTablePrice(null) => ''
/// ```
String formatTablePrice(num? number, [int decimalDigits = 2]) => FormatPrice(
      decimalDigits: decimalDigits,
      symbol: '',
    ).format(number);
