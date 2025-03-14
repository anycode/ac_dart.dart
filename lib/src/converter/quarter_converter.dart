import 'package:ac_dart/ac_dart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
/// QuarterConverter annotation
///
/// Quarter is a numeric representation of quarter of the year.
/// Q1 is for Jan-Mar, Q2 for Apr-Jun, Q3 for Jul-Sep, Q4 for Oct-Dec.
///
/// Format used to represent quarter is `yyyy'q'n`, where `yyyy` is year and `n` is
/// number 1-4, eg. 2024q3, 2025q1 etc.
///
/// It's handy when processing JSON-like Map where quarter is already preprocessed by caller (e.g. database driver)
/// e.g.
/// @JsonKey(name: 'quarter')
/// @QuarterConverter()
/// Quarter quarter;
///
class QuarterConverter implements JsonConverter<DateTime, Object>, PgSqlConverter<DateTime, Object> {
  static final _quarterRE = RegExp(r'(\d{4})q(\d)', caseSensitive: false);

  const QuarterConverter();

  /// Converts a [json] object to a DateTime representing the quarter.
  ///
  /// If the quarter is already of DateTime type return date truncated to quarter, otherwise try to parse String.
  @override
  DateTime fromJson(Object? json) {
    if (json is DateTime) {
      return json.trunc(DateTimeExt.unitQuarter);
    } else if (json is String) {
      return _parse(json);
    } else {
      throw Exception('Invalid input for quarter');
    }
  }

  /// Converts a [quarter] DateTime to a string representation in the format `yyyy'q'n`.
  @override
  String toJson(DateTime quarter) => _format(quarter);

  /// Converts a [object] from PgSql to a DateTime representing the quarter.
  @override
  DateTime fromPgSql(Object object) => fromJson(object);

  /// Converts a [quarter] DateTime to a string representation for PgSql.
  @override
  String toPgSql(DateTime quarter) => quarter.toIso8601String();

  static DateTime _parse(String input) {
    DateTime dateTime;
    if (_quarterRE.hasMatch(input)) {
      final match = _quarterRE.firstMatch(input)!;
      final quarter = int.parse(match[2]!);
      dateTime = DateTime(int.parse(match[1]!), quarter * 3 - 2, 1);
    } else {
      final dt = DateTime.parse(input);
      dateTime = DateTime(dt.year, dt.quarter * 3 - 2, 1);
    }
    return dateTime;
  }

  static String _format(DateTime quarter) => '${quarter.year}q${quarter.quarter}';
}

///
///  QuarterListConverter annotation
///  If the quarter is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where quarter is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'dates')
///  @QuarterListConverter()
///  List<DateTime> dates;
///
class QuarterListConverter implements JsonConverter<List<DateTime>, List<Object>>, PgSqlConverter<List<DateTime>, List<Object>> {
  const QuarterListConverter();

  /// Converts a [json] list of objects to a list of DateTimes representing the quarters.
  @override
  List<DateTime> fromJson(List<Object> json) {
    const converter = QuarterConverter();
    return json.map((input) => converter.fromJson(input)).toList();
  }

  /// Converts a [quarters] list of DateTimes to a list of string representations in the format `yyyy'q'n`.
  @override
  List<String> toJson(List<DateTime> quarters) {
    const converter = QuarterConverter();
    return quarters.map((quarter) => converter.toJson(quarter)).toList();
  }

  @override
  /// Converts a [object] list from PgSql to a list of DateTimes representing the quarters.
  List<DateTime> fromPgSql(List<Object> object) => fromJson(object);

  /// Converts a [datesTimes] list of DateTimes to a list of string representations for PgSql.
  @override
  List<Object> toPgSql(List<DateTime> datesTimes) => datesTimes.map((quarter) => quarter.toIso8601String()).toList();
}
