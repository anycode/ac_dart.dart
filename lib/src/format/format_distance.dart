import 'package:intl/intl.dart';

/// Units to be used for formatting distance
enum FormatDistanceUnit {
  /// kilometer (1000 meters)
  km(1000, 'km'),

  /// meter (base unit)
  m(1, 'm'),

  /// decimeter (10th of meter)
  dm(0.1, 'dm'),

  /// centimeter (100th of meter)
  cm(0.01, 'cm'),

  /// millimeter (1000th of meter)
  mm(0.001, 'mm'),

  /// nanometer (1000000th of meter)
  nm(0.000001, 'nm'),

  /// standard mile (1609.344 meters)
  mi(1609.344, 'mi'),

  /// yard (0.9144 of meter)
  yd(0.9144, 'yd'),

  /// foot (0.3048 of meter)
  ft(0.3048, 'ft'),

  /// inch (0.0254 of meter)
  inch(0.0254, 'in'),

  /// nautical mile (1852 meters)
  nmi(1852, 'NM');

  /// modulo to convert unit to one meter
  final double modulo;

  /// name of the unit
  final String name;

  /// Creates FormatDistanceUnit
  const FormatDistanceUnit(this.modulo, this.name);

  /// Returns [FormatDistanceUnit] by its name, or `meter` if not found.
  static FormatDistanceUnit byName(String unit) {
    return FormatDistanceUnit.values.firstWhere((u) => u.name == unit, orElse: () => m);
  }

  /// Returns [FormatDistanceUnit] by its modulo, or `meter` if not found.
  static FormatDistanceUnit byModulo(double modulo) {
    return FormatDistanceUnit.values.firstWhere((u) => u.modulo == modulo, orElse: () => m);
  }
}

/// Helper class for formatting distance
class FormatDistance {
  static final _cache = <int, FormatDistance>{};

  final NumberFormat _format;

  /// Formatted value to be displayed instead of null value
  final String emptyValue;

  /// Base modulo of unit, used for conversion of input values to meters.
  final double baseModulo;

  /// Whether to show units
  final bool showUnits;

  /// Creates a [FormatDistance] for formatting distance.
  ///
  /// * [decimalDigits] is number of decimal digits to be displayed
  /// * [emptyValue] is a string to be displayed when formatted value is null, default ''
  /// * Date is formatted in [locale], default `cs_CZ`
  /// * Input values for [format()] are in [unit] by default
  factory FormatDistance(
      {int decimalDigits = 2,
      String emptyValue = '',
      String locale = 'cs_CZ',
      bool grouping = true,
      bool showUnits = true,
      FormatDistanceUnit unit = FormatDistanceUnit.m}) {
    return _cache.putIfAbsent(
        decimalDigits.hashCode ^ locale.hashCode ^ emptyValue.hashCode ^ grouping.hashCode ^ showUnits.hashCode ^ unit.hashCode,
        () => FormatDistance._(decimalDigits, locale, emptyValue, grouping, showUnits, unit.modulo));
  }

  FormatDistance._(int decimals, String locale, this.emptyValue, bool grouping, this.showUnits, this.baseModulo)
      : _format = NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimals) {
    if (!grouping) {
      _format.turnOffGrouping();
    }
  }

  /// Returns formatted [number] of [unit] as [as].
  /// If [unit] is not specified here, [FormatDistance.unit] passed to constructor is used.
  /// If the [number] is null, [emptyValue] is returned. If [emptyValue] is not specified here, [FormatDistance.emptyValue] is used.
  /// If [showUnits] is false, units are not shown.
  /// If [showUnits] is not specified here, [FormatDistance.showUnits] is used.
  ///
  /// Example: create an object, which will convert yards to other units
  /// ```dart
  /// final fd = FormatDistance(unit: yd);
  /// fd.format(3065, as: mi);    // format 3065 yards as miles
  /// fd.format(13.67, as: inch); // format 13.67 yards as inches
  ///
  /// fd.format(500, unit: km, as: nmi);  // override `unit`, format 500 km as nautical miles
  /// fd.format(null, emptyValue: 'NaN'); // override `emptyValue`, show 'NaN' for null value
  /// ```
  format(
    num? number, {
    FormatDistanceUnit as = FormatDistanceUnit.m,
    FormatDistanceUnit? unit,
    String? emptyValue,
    bool? showUnits,
  }) =>
      number == null
          ? (emptyValue ?? this.emptyValue)
          : '${_format.format(number * (unit?.modulo ?? baseModulo) / as.modulo)}${(showUnits ?? this.showUnits) ? ' ${as.name}' : ''}';
}

/// Global shorthand to `FormatDistance({int decimalDigits}).format(num? number)`
///
/// Formats a number as a distance **in metres** in a human readable form.
///
/// * [distance] is a value in **meters** to be formatted
/// * [decimal] is a number of decimal numbers, default 2
/// * [unit] is a name of a unit, it's converted to a [FormatDistanceUnit] by name, default meter
/// * [modulo] is a divider, ignored
///
/// eg. format 2310 metres as kilometres
/// ```
/// formatDistance(2310, unit: 'km', modulo: 1000);
/// ```
String formatDistance(num? distance, {int decimalDigits = 2, String unit = 'm', double modulo = 1.0}) =>
    FormatDistance(decimalDigits: decimalDigits).format(distance, as: FormatDistanceUnit.byName(unit));

/// Global shorthand to `FormatDistance({int decimalDigits}).format(num? number)`
///
/// Formats a number as a distance **in metres** in a machine readable form.
///
/// * [distance] is a value in **meters** to be formatted
/// * [decimal] is a number of decimal numbers, default 2
/// * [modulo] is a divider, it's converted to a [FormatDistanceUnit] by modulo, default meter
///
/// eg. format 2310 metres as kilometres
/// ```
/// formatCsvDistance(2310, modulo: 1000);
/// ```
String formatCsvDistance(num? distance, {double modulo = 1.0, int decimalDigits = 2}) =>
    FormatDistance(decimalDigits: decimalDigits, grouping: false, showUnits: false)
        .format(distance, as: FormatDistanceUnit.byModulo(modulo));

/// Global shorthand to `FormatDistance({int decimalDigits}).format(num? number)`
///
/// Formats a number as a distance **in metres** in a human readable form but without units.
///
/// * [distance] is a value in **meters** to be formatted
/// * [decimal] is a number of decimal numbers, default 2
/// * [modulo] is a divider, it's converted to a [FormatDistanceUnit] by modulo, default meter
///
/// eg. format 2310 metres as kilometres
/// ```
/// formatTableDistance(2310, modulo: 1000);
/// ```
String formatTableDistance(num? distance, {double modulo = 1.0, int decimalDigits = 2}) =>
    FormatDistance(decimalDigits: decimalDigits, showUnits: false).format(distance, as: FormatDistanceUnit.byModulo(modulo));
