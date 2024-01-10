import 'package:ac_dart/ac_dart.dart';
import 'package:ac_dart/src/format/format_distance.dart' as df;
import 'package:ac_dart/src/format/format_number.dart' as nf;
import 'package:ac_dart/src/format/format_percent.dart' as pctf;
import 'package:ac_dart/src/format/format_price.dart' as pf;

extension NumExt on num {
  /// Extension method for formatting numbers in human readable format. See [nf.formatNumber] function for details.
  String format([int decimalDigits = 2]) => nf.formatNumber(this, decimalDigits);

  /// Extension method for formatting numbers in machine readable format. See [nf.formatCsvNumber] function for details.
  String formatCsv([int decimalDigits = 2]) => nf.formatCsvNumber(this, decimalDigits);

  /// Extension method for formatting numbers for PDF. See [number.formatPdfNumber] function for details.
  String formatTable([int decimalDigits = 2]) => nf.formatTableNumber(this, decimalDigits);

  /// Extension method for formatting prices in human readable format. See [pf.formatPrice] function for details.
  String formatPrice([int decimalDigits = 2]) => pf.formatPrice(this, decimalDigits);

  /// Extension method for formatting prices in machine readable format. See [pf.formatCsvPrice] function for details.
  String formatCsvPrice([int decimalDigits = 2]) => pf.formatCsvPrice(this, decimalDigits);

  /// Extension method for formatting numbers for tables. See [pf.formatTablePrice] function for details.
  String formatTablePrice([int decimalDigits = 2]) => pf.formatTablePrice(this, decimalDigits);

  /// Extension method for formatting percents in human readable format. See [pctf.formatPercent] function for details.
  String formatPercent([int decimalDigits = 2]) => pctf.formatPercent(this, decimalDigits);

  /// Extension method for formatting percents in machine readable format. See [pctf.formatCsvPercent] function for details.
  String formatCsvPercent([int decimalDigits = 2]) => pctf.formatCsvPercent(this, decimalDigits);

  /// Extension method for formatting numbers for tables. See [pctf.formatTablePercent] function for details.
  String formatTablePercent([int decimalDigits = 2]) => pctf.formatTablePercent(this, decimalDigits);

  /// Shorthand to `FormatDistance({int decimal, FormatDistanceUnit baseUnit}).format(num? number, {FormatDistanceUnit unit})`
  String formatDistance({int decimalDigits = 2, String unit = 'm'}) => df.formatDistance(this, decimalDigits: decimalDigits, unit: unit);

  /// Shorthand to `FormatDistance({int decimal, FormatDistanceUnit baseUnit}).formatCsv(num? number, {FormatDistanceUnit unit})`
  String formatCsvDistance({int decimalDigits = 2, double modulo = 1.0}) =>
      df.formatCsvDistance(this, modulo: modulo, decimalDigits: decimalDigits);

  /// Shorthand to `FormatDistance({int decimal, FormatDistanceUnit baseUnit}).formatPdf(num? number, {FormatDistanceUnit unit})`
  String formatTableDistance({int decimalDigits = 2, double modulo = 1.0}) =>
      df.formatTableDistance(this, modulo: modulo, decimalDigits: decimalDigits);
}

extension DoubleExt on double {
  /// Shorthand to `FormatLatitude().formatD(num? number, {int decimal})`
  String formatLatitudeD({int decimalDigits = 6}) => FormatLatitude().formatD(this, decimalDigits: decimalDigits);

  /// Shorthand to `FormatLatitude().formatDM(num? number, {int decimal})`
  String formatLatitudeDM({int decimalDigits = 4}) => FormatLatitude().formatDM(this, decimalDigits: decimalDigits);

  /// Shorthand to `FormatLatitude().formatDMS(num? number, {int decimal})`
  String formatLatitudeDMS({int decimalDigits = 3}) => FormatLatitude().formatDMS(this, decimalDigits: decimalDigits);

  /// Shorthand to `FormatLongitude().formatD(num? number, {int decimal})`
  String formatLongitudeD({int decimalDigits = 6}) => FormatLongitude().formatD(this, decimalDigits: decimalDigits);

  /// Shorthand to `FormatLongitude().formatDM(num? number, {int decimal})`
  String formatLongitudeDM({int decimalDigits = 4}) => FormatLongitude().formatDM(this, decimalDigits: decimalDigits);

  /// Shorthand to `FormatLongitude().formatDMS(num? number, {int decimal})`
  String formatLongitudeDMS({int decimalDigits = 3}) => FormatLongitude().formatDMS(this, decimalDigits: decimalDigits);
}
