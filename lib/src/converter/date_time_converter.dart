import 'package:ac_dart/src/extensions/datetime_ext.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

///
///  DateTimeConverter annotation
///  If the datetime is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'date')
///  @DateTimeConverter()
///  DateTime date;
///
class DateTimeConverter implements JsonConverter<DateTime, Object> {
  const DateTimeConverter();

  // DateTimes can represent time values that are at a distance of at most 100,000,000
  // days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
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
        return DateTime.parse(json);
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
      return dateTime.toUtc().toIso8601StringTZD();
    }
  }
}

///
///  DateTimeListConverter annotation
///  If the datetime is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'dates')
///  @DateTimesConverter()
///  List<DateTime> dates;
///
class DateTimeListConverter implements JsonConverter<List<DateTime>, Object> {
  const DateTimeListConverter();

  @override
  List<DateTime> fromJson(Object json) {
    const converter = DateTimeConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    const converter = DateTimeConverter();
    return datesTimes.map((DateTime dateTime) => converter.toJson(dateTime)).toList();
  }
}

///
///  DateConverter annotation
///  If the date is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where date is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'date')
///  @DateConverter()
///  DateTime date;
///
class DateConverter implements JsonConverter<DateTime, Object> {
  static final DateFormat _format = DateFormat('yyyy-MM-dd');

  const DateConverter();

  // DateTimes can represent time values that are at a distance of at most 100,000,000
  // days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
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
}

///
///  DateTimeListConverter annotation
///  If the datetime is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'dates')
///  @DateTimesConverter()
///  List<DateTime> dates;
///
class DateListConverter implements JsonConverter<List<DateTime>, Object> {
  const DateListConverter();

  @override
  List<DateTime> fromJson(Object json) {
    const converter = DateConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    const converter = DateConverter();
    return datesTimes.map((DateTime dateTime) => converter.toJson(dateTime)).toList();
  }
}

///
///  TimeConverter annotation
///  If the time is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'time')
///  @TimeConverter()
///  DateTime date;
///
class TimeConverter implements JsonConverter<DateTime, dynamic> {
  static final DateFormat _format = DateFormat('HH:mm');

  const TimeConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is DateTime) return json.toLocal();
    if (json is String) return _format.parse(json).toLocal();
    throw Exception('Invalid input for Time');
  }

  @override
  String toJson(DateTime dateTime) {
    return _format.format(dateTime.toLocal());
  }
}

///
///  TimeListConverter annotation
///  If the time is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'times')
///  @TimesConverter()
///  List<DateTime> times;
///
class TimeListConverter implements JsonConverter<List<DateTime>, Object> {
  const TimeListConverter();

  @override
  List<DateTime> fromJson(Object json) {
    const converter = TimeConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    const converter = TimeConverter();
    return datesTimes.map((DateTime dateTime) => converter.toJson(dateTime)).toList();
  }
}
