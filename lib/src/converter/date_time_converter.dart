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

  final bool _useUtc;

  @Deprecated('Use DateTimeConverter.utc() instead, or use DateTimeConverter.local() if you need local time')
  const DateTimeConverter() : _useUtc = true;
  const DateTimeConverter.utc() : _useUtc = true;
  const DateTimeConverter.local() : _useUtc = false;

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
        final dateTime = DateTime.parse(json);
        return _useUtc ? dateTime.toUtc() : dateTime.toLocal();
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
      if (_useUtc) {
        return dateTime.toUtc().toIso8601StringTZD();
      } else {
        return dateTime.toLocal().toIso8601StringTZD();
      }
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
  final bool _useUtc;

  @Deprecated('Use DateTimeListConverter.utc() instead, or use DateTimeListConverter.local() if you need local time')
  const DateTimeListConverter() : _useUtc = true;
  const DateTimeListConverter.utc() : _useUtc = true;
  const DateTimeListConverter.local() : _useUtc = false;

  @override
  List<DateTime> fromJson(Object json) {
    final converter = _useUtc ? DateTimeConverter.utc() : DateTimeConverter.local();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = _useUtc ? DateTimeConverter.utc() : DateTimeConverter.local();
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
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
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
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
class TimeConverter implements JsonConverter<DateTime, Object> {
  static final DateFormat _formatHm = DateFormat.Hm();
  static final DateFormat _formatHms = DateFormat.Hms();

  final bool _withSeconds;
  
  @Deprecated('Use TimeConverter.hm() instead, or use TimeConverter.hms() if you need to convert time including seconds')
  const TimeConverter() : _withSeconds = false;
  const TimeConverter.hm() : _withSeconds = false;
  const TimeConverter.hms() : _withSeconds = true;

  @override
  DateTime fromJson(Object json) {
    if (json is DateTime) {
      return json.toLocal();
    } else if (json is String) {
      return _withSeconds ? _formatHms.parse(json).toLocal() : _formatHm.parse(json).toLocal();
    } else {
      throw Exception('Invalid input for Time');
    }
  }

  @override
  String toJson(DateTime dateTime) {
    return _withSeconds ? _formatHms.format(dateTime.toLocal()) : _formatHm.format(dateTime.toLocal());
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
class TimeListConverter implements JsonConverter<List<DateTime>, List<Object>> {
  final bool _withSeconds;

  @Deprecated('Use TimeListConverter.hm() instead, or use TimeListConverter.hms() if you need to convert time including seconds')
  const TimeListConverter() : _withSeconds = false;

  const TimeListConverter.hm() : _withSeconds = false;

  const TimeListConverter.hms() : _withSeconds = true;

  @override
  List<DateTime> fromJson(List<Object> json) {
    final converter = _withSeconds ? TimeConverter.hms() : TimeConverter.hm();
    return json.map((input) => converter.fromJson(input)).toList();
  }

  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = _withSeconds ? TimeConverter.hms() : TimeConverter.hm();
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }
}
