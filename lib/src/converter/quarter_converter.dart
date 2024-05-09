import 'package:ac_dart/ac_dart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
///  QuarterConverter annotation
///  If the quarter is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where quarter is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'quarter')
///  @QuarterConverter()
///  Quarter quarter;
///
class QuarterConverter implements JsonConverter<DateTime, Object>, PgSqlConverter<DateTime, Object> {
  static final _quarterRE = RegExp(r'(\d{4})q(\d)', caseSensitive: false);

  const QuarterConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is DateTime) {
      return json;
    } else if (json is String) {
      return _parse(json);
    } else {
      throw Exception('Invalid input for quarter');
    }
  }

  @override
  String toJson(DateTime quarter) {
    return _format(quarter);
  }

  @override
  DateTime fromPgSql(Object object) {
    return fromJson(object);
  }

  @override
  String toPgSql(DateTime quarter) {
    return quarter.toString();
  }

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

  @override
  List<DateTime> fromJson(List<Object> json) {
    const converter = QuarterConverter();
    return json.map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> quarters) {
    const converter = QuarterConverter();
    return quarters.map((quarter) => converter.toJson(quarter)).toList();
  }

  @override
  List<DateTime> fromPgSql(List<Object> object) {
    return fromJson(object);
  }

  @override
  List<Object> toPgSql(List<DateTime> datesTimes) {
    return datesTimes.map((quarter) => quarter.toIso8601String()).toList();
  }
}
