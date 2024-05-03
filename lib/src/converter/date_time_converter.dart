import 'package:ac_dart/src/extensions/datetime_ext.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
///  Use DateTimeConverter annotation with the DateTime members, e.g.
///  ```dart
///  @JsonKey(name: 'date')
///  @DateTimeConverter()
///  DateTime date;
///  ```
///  DateTime can be UTC or local time.
///
///  There are two special values that can be used for the datetime: `-infinity` and `infinity` which
///  hold the minimum and maximum datetime values respectively.
///
///  If the datetime is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///
class DateTimeConverter implements JsonConverter<DateTime, Object>, PgSqlConverter<DateTime, Object> {

  final bool utc;

  /// Const constructor to create DateTimeConverter with UTC time (default). If you need local time
  /// pass `utc: false`
  const DateTimeConverter({this.utc = true});

  // DateTimes can represent time values that are at a distance of at most 100,000,000
  // days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
  /// Minimal datetime value used as `-infinity`
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  /// Maximal datetime value used as `infinity`
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json;
    } else if (json is String) {
      if (json == '-infinity') {
        return minDateTime;
      } else if (json == 'infinity') {
        return maxDateTime;
      } else {
        final dateTime = DateTime.parse(json);
        return utc ? dateTime.toUtc() : dateTime.toLocal();
      }
    } else {
      throw Exception('Invalid input for DateTime');
    }
  }

  @override
  String toJson(DateTime dateTime) {
    if (dateTime == minDateTime) {
      return '-infinity';
    } else if (dateTime == maxDateTime) {
      return 'infinity';
    } else {
      if (utc) {
        return dateTime.toUtc().toIso8601StringTZD();
      } else {
        return dateTime.toLocal().toIso8601StringTZD();
      }
    }
  }

  @override
  DateTime fromPgSql(Object object) => fromJson(object);

  @override
  String toPgSql(DateTime datetime) => toJson(datetime);
}

///
///  Use DateTimeListConverter annotation with the List of DateTime members, e.g.
///  ```dart
///  @JsonKey(name: 'dates')
///  @DateTimesConverter()
///  List<DateTime> dates;
///  ```
///  See [DateTimeConverter] for details
///
class DateTimeListConverter implements JsonConverter<List<DateTime>, Object>, PgSqlConverter<List<DateTime>, List<Object>> {
  final bool utc;

  /// Const constructor to create DateTimeListConverter with UTC time (default). If you need local time
  /// pass `utc: false`
  const DateTimeListConverter({this.utc = true});

  @override
  List<DateTime> fromJson(Object json) {
    final converter = DateTimeConverter(utc: utc);
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = DateTimeConverter(utc: utc);
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }

  @override
  List<DateTime> fromPgSql(List<Object> object) => fromJson(object);

  @override
  List<String> toPgSql(List<DateTime> datesTimes) => toJson(datesTimes);
}

///
///  Use DateConverter annotation with the DateTime members used to store date, e.g.
///  ```dart
///  @JsonKey(name: 'date')
///  @DateConverter()
///  DateTime date;
///  ```
///  There are two special values that can be used for the date: `-infinity` and `infinity` which
///  hold the minimum and maximum date values respectively.
///
///  If the date is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where date is already preprocessed by caller (e.g. database driver)
///
class DateConverter implements JsonConverter<DateTime, Object>, PgSqlConverter<DateTime, Object> {
  static final DateFormat _format = DateFormat('yyyy-MM-dd');

  const DateConverter();

  // DateTimes can represent time values that are at a distance of at most 100,000,000
  // days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
  /// Minimal datetime value used as `-infinity`
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  /// Maximal datetime value used as `infinity`
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json.toLocal();
    } else if (json is String) {
      if (json == '-infinity') {
        return minDateTime;
      } else if (json == 'infinity') {
        return maxDateTime;
      } else {
        return _format.parse(json).toLocal();
      }
    } else {
      throw Exception('Invalid input for Date');
    }
  }

  @override
  String toJson(DateTime dateTime) {
    if (dateTime == minDateTime) {
      return '-infinity';
    } else if (dateTime == maxDateTime) {
      return 'infinity';
    } else {
      return _format.format(dateTime.toLocal());
    }
  }

  @override
  DateTime fromPgSql(Object pgsql) => fromJson(pgsql);

  @override
  String toPgSql(DateTime dateTime) => toJson(dateTime);
}

///
///  Use DateListConverter annotation with the List of DateTime members used to store dates, e.g.
///  ```dart
///  @JsonKey(name: 'dates')
///  @DateTimesConverter()
///  List<DateTime> dates;
///  ```
///  See [DateConverter] for details
///
class DateListConverter implements JsonConverter<List<DateTime>, Object>, PgSqlConverter<List<DateTime>, List<Object>> {
  const DateListConverter();

  @override
  List<DateTime> fromJson(Object json) {
    const converter = DateConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    const converter = DateConverter();
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }

  @override
  List<DateTime> fromPgSql(List<Object> object) => fromJson(object);

  @override
  List<String> toPgSql(List<DateTime> datesTimes) => toJson(datesTimes);
}

///
///  Use TimeConverter annotation with the DateTime members used to store time, e.g.
///  ```dart
///  @JsonKey(name: 'time')
///  @TimeConverter()
///  DateTime time;
///  ```
///  Can be used to store time excluding seconds (use [TimeConverter.hm()]),
///  or time including seconds (use [TimeConverter.hms()])
///
///  If the time is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///
class TimeConverter implements JsonConverter<DateTime, Object>, PgSqlConverter<DateTime, Object> {
  static final DateFormat _formatHm = DateFormat.Hm();
  static final DateFormat _formatHms = DateFormat.Hms();

  final bool includeSeconds;

  /// Const constructor used to convert time excluding seconds (default), if you need time including seconds
  /// pass `includeSeconds: true`
  const TimeConverter({this.includeSeconds = false});

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json.toLocal();
    } else if (json is String) {
      return includeSeconds ? _formatHms.parse(json).toLocal() : _formatHm.parse(json).toLocal();
    } else {
      throw Exception('Invalid input for Time');
    }
  }

  @override
  String toJson(DateTime dateTime) {
    return includeSeconds ? _formatHms.format(dateTime.toLocal()) : _formatHm.format(dateTime.toLocal());
  }

  @override
  DateTime fromPgSql(Object pgsql) => fromJson(pgsql);

  @override
  String toPgSql(DateTime dateTime) => toJson(dateTime);
}

///
///  Use TimeListConverter annotation with the List of DateTime members used to store time, e.g.
///  ```dart
///  @JsonKey(name: 'times')
///  @TimesConverter()
///  List<DateTime> times;
///  ```
///  See [TimeConverter] for details
///
class TimeListConverter implements JsonConverter<List<DateTime>, List<Object>>, PgSqlConverter<List<DateTime>, List<Object>> {
  final bool includeSeconds;

  /// Const constructor used to convert time excluding seconds (default), if you need time including seconds
  /// pass `includeSeconds: true`
  const TimeListConverter({this.includeSeconds = false});

  @override
  List<DateTime> fromJson(List<Object> json) {
    final converter = TimeConverter(includeSeconds: includeSeconds);
    return json.map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = TimeConverter(includeSeconds: includeSeconds);
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }

  @override
  List<DateTime> fromPgSql(List<Object> object) => fromJson(object);

  @override
  List<Object> toPgSql(List<DateTime> datesTimes) => toJson(datesTimes);
}
