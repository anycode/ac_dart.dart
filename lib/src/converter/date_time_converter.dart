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

import 'package:ac_dart/src/extensions/datetime_ext.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

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
class DateTimeConverter implements JsonConverter<DateTime, Object> {

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


  /// Converts [json] object to [DateTime]. [json] can be [DateTime] or a string representation of [DateTime].
  ///
  /// If it's `-infinity` or `infinity` returns [minDateTime] or [maxDateTime] respectively.
  /// Otherwise parses [json] as [DateTime] and converts it to UTC or local time based on [utc] flag.
  ///
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

  /// Converts [dateTime] to [String].
  ///
  /// If [dateTime] is [minDateTime] or [maxDateTime] returns `-infinity` or `infinity` respectively.
  /// Otherwise converts [dateTime] to UTC or local time based on [utc] flag and returns ISO 8601 string with time zone designator.
  ///
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
class DateTimeListConverter implements JsonConverter<List<DateTime>, Object> {
  final bool utc;

  /// Const constructor to create DateTimeListConverter with UTC time (default). If you need local time
  /// pass `utc: false`
  const DateTimeListConverter({this.utc = true});

  /// Converts [json] to [List<DateTime>].
  ///
  /// Converts each element of [json] to [DateTime] using [DateTimeConverter].
  @override
  List<DateTime> fromJson(Object json) {
    final converter = DateTimeConverter(utc: utc);
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  /// Converts [datesTimes] to [List<String>].
  ///
  /// Converts each element of [datesTimes] to [String] using [DateTimeConverter].
  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = DateTimeConverter(utc: utc);
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }
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
class DateConverter implements JsonConverter<DateTime, Object> {
  static final DateFormat _format = DateFormat('yyyy-MM-dd');

  const DateConverter();

  // DateTimes can represent time values that are at a distance of at most 100,000,000
  // days from epoch (1970-01-01 UTC): -271821-04-20 to 275760-09-13.
  /// Minimal datetime value represents `-infinity`
  static DateTime minDateTime = DateTime.utc(-271821, 04, 20);
  /// Maximal datetime value represents `infinity`
  static DateTime maxDateTime = DateTime.utc(275760, 09, 13);

  /// Converts [json] to [DateTime].
  ///
  /// If [json] is [DateTime] returns it as local time.
  /// If [json] is [String] and equals to `-infinity` or `infinity` returns [minDateTime] or [maxDateTime] respectively.
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

  /// Converts [dateTime] to [String].
  ///
  /// If [dateTime] is [minDateTime] or [maxDateTime] returns `-infinity` or `infinity` respectively.
  /// Otherwise converts [dateTime] to local time and returns formatted string.
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
///  Use DateListConverter annotation with the List of DateTime members used to store dates, e.g.
///  ```dart
///  @JsonKey(name: 'dates')
///  @DateTimesConverter()
///  List<DateTime> dates;
///  ```
///  See [DateConverter] for details
///
class DateListConverter implements JsonConverter<List<DateTime>, Object> {
  const DateListConverter();

  /// Converts [json] to [List<DateTime>].
  ///
  /// Converts each element of [json] to [DateTime] using [DateConverter].
  @override
  List<DateTime> fromJson(Object json) {
    const converter = DateConverter();
    return (json as List).map((input) => converter.fromJson(input)).toList();
  }

  /// Converts [dates] to [List<String>].
  ///
  /// Converts each element of [dates] to [String] using [DateConverter].
  @override
  List<String> toJson(List<DateTime> dates) {
    const converter = DateConverter();
    return dates.map((dateTime) => converter.toJson(dateTime)).toList();
  }
}

///
///  Use TimeConverter annotation with the DateTime members used to store time, e.g.
///  ```dart
///  @JsonKey(name: 'time')
///  @TimeConverter()
///  DateTime time;
///  ```
///  Can be used to store time excluding seconds (use [TimeConverter()]),
///  or time including seconds (use [TimeConverter(includeSeconds: true)])
///
///  If the time is already of DateTime type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where datetime is already preprocessed by caller (e.g. database driver)
///
class TimeConverter implements JsonConverter<DateTime, Object> {
  static final DateFormat _formatHm = DateFormat.Hm();
  static final DateFormat _formatHms = DateFormat.Hms();

  final bool includeSeconds;

  /// Const constructor used to convert time excluding seconds (default), if you need time including seconds
  /// pass `includeSeconds: true`
  const TimeConverter({this.includeSeconds = false});

  /// Converts [json] to [DateTime].
  ///
  /// If [json] is [DateTime] returns it as local time.
  /// If [json] is [String] parses it as time and returns it as local time.
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

  /// Converts [dateTime] to [String].
  ///
  /// Returns formatted string based on [includeSeconds] flag.
  @override
  String toJson(DateTime dateTime) {
    return includeSeconds ? _formatHms.format(dateTime.toLocal()) : _formatHm.format(dateTime.toLocal());
  }
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
class TimeListConverter implements JsonConverter<List<DateTime>, List<Object>> {
  final bool includeSeconds;

  /// Const constructor used to convert time excluding seconds (default), if you need time including seconds
  /// pass `includeSeconds: true`
  const TimeListConverter({this.includeSeconds = false});

  /// Converts [json] to [List<DateTime>].
  ///
  /// Converts each element of [json] to [DateTime] using [TimeConverter].
  @override
  List<DateTime> fromJson(List<Object> json) {
    final converter = TimeConverter(includeSeconds: includeSeconds);
    return json.map((input) => converter.fromJson(input)).toList();
  }

  /// Converts [datesTimes] to [List<String>].
  ///
  /// Converts each element of [datesTimes] to [String] using [TimeConverter].
  @override
  List<String> toJson(List<DateTime> datesTimes) {
    final converter = TimeConverter(includeSeconds: includeSeconds);
    return datesTimes.map((dateTime) => converter.toJson(dateTime)).toList();
  }
}
