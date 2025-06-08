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

import 'package:intl/intl.dart';

/// Helper class for formatting datetime
class FormatDateTime {
  static final _cache = <int, FormatDateTime>{};

  final DateFormat _format;

  /// Formatted value to be displayed instead of null value
  final String emptyValue;

  /// Creates an object for formatting [DateTime]
  ///
  /// * [format] is required format of the datetime
  /// * [emptyValue] is a string to be displayed when formatted value is null, default ''
  /// * Datetime is formatted in [locale], default `cs_CZ`
  factory FormatDateTime({required String format, String emptyValue = '', String locale = 'cs_CZ'}) {
    return FormatDateTime._f(format: DateFormat(format, locale), emptyValue: emptyValue);
  }

  factory FormatDateTime._f({required DateFormat format, String emptyValue = ''}) {
    return _cache.putIfAbsent(format.hashCode ^ emptyValue.hashCode,
            () => FormatDateTime._(format, emptyValue));
  }

  /// Shorthand to create [FormatDateTime] which uses [DateFormat.MEd.Hm]
  factory FormatDateTime.short({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatDateTime._f(format: DateFormat.yMEd(locale).add_Hm(), emptyValue: emptyValue);

  /// Shorthand to create FormatDateTime which uses [DateFormat.yMMMEd.Hms]
  factory FormatDateTime.long({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatDateTime._f(format: DateFormat.yMMMEd(locale).add_Hms(), emptyValue: emptyValue);

  FormatDateTime._(this._format, this.emptyValue);

  /// Formats passed [dateTime] using [format], if null is passed, [emptyValue] is returned.
  ///
  /// e.g.
  /// ```dart
  /// FormatDateTime.short().format(DateTime.now())
  /// ```
  String format(DateTime? dateTime) => dateTime == null ? emptyValue : _format.format(dateTime);
}

/// Global shorthand to `FormatDateTime.short().format(DateTime.now())`
String formatDateTimeShort(DateTime? date) => FormatDateTime.short().format(date);

/// Global shorthand to `FormatDateTime.long().format(DateTime.now())`
String formatDateTimeLong(DateTime? date) => FormatDateTime.long().format(date);

/// Global shorthand to `FormatDateTime.short().format(DateTime.now())`. It's same as [formatDateTimeShort].
String formatDateTime(DateTime? date) => FormatDateTime.short().format(date);

/// Helper class for formatting date
class FormatDate {
  static final _cache = <int, FormatDate>{};

  final DateFormat _format;
  /// Formatted value to be displayed instead of null value
  final String emptyValue;

  /// Creates an object for formatting [DateTime] as date
  ///
  /// * [format] is required format of the datetime
  /// * [emptyValue] is a string to be displayed when formatted value is null, default ''
  /// * Date is formatted in [locale], default `cs_CZ`
  factory FormatDate({required String format, String emptyValue = '', String locale = 'cs_CZ'}) {
    return FormatDate._f(format: DateFormat(format, locale), emptyValue: emptyValue);
  }

  factory FormatDate._f({required DateFormat format, String emptyValue = ''}) {
    return _cache.putIfAbsent(format.hashCode ^ emptyValue.hashCode,
            () => FormatDate._(format, emptyValue));
  }

  /// Shorthand to create FormatDate which uses [DateFormat.MEd]
  factory FormatDate.short({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatDate._f(format: DateFormat.MEd(locale), emptyValue: emptyValue);

  /// Shorthand to create FormatDate which uses [DateFormat.yMMMEd]
  factory FormatDate.long({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatDate._f(format: DateFormat.yMMMEd(locale), emptyValue: emptyValue);

  FormatDate._(this._format, this.emptyValue);

  /// Formats passed [dateTime] using [format], if null is passed, [emptyValue] is returned.
  ///
  /// e.g.
  /// ```dart
  /// FormatDate.long().format(DateTime.now())
  /// ```
  String format(DateTime? dateTime) => dateTime == null ? emptyValue : _format.format(dateTime);
}

/// Global shorthand to `FormatDate.short().format(DateTime.now())`
String formatDateShort(DateTime? date) => FormatDate.short().format(date);

/// Global shorthand to `FormatDate.long().format(DateTime.now())`
String formatDateLong(DateTime? date) => FormatDate.long().format(date);

/// Global shorthand to `FormatDate.short().format(DateTime.now())`. It's same as [formatDateShort].
String formatDate(DateTime? date) => FormatDate.short().format(date);

/// Global shorthand to `FormatDate(format: 'dd.MM.yyyy').format(date)`.
String formatBirthDate(DateTime? date) => FormatDate(format: 'dd.MM.yyyy').format(date);

/// Helper class for formatting time
class FormatTime {
  static final _cache = <int, FormatTime>{};

  final DateFormat _format;
  /// Formatted value to be displayed instead of null value
  final String emptyValue;

  /// Creates an object for formatting [DateTime] as time
  ///
  /// * [format] is required format of the time
  /// * [emptyValue] is a string to be displayed when formatted value is null, default ''
  /// * Datetime is formatted in [locale], default `cs_CZ`
  factory FormatTime({required String format, String emptyValue = '', String locale = 'cs_CZ'}) {
    return FormatTime._f(format: DateFormat(format, locale), emptyValue: emptyValue);
  }

  factory FormatTime._f({required DateFormat format, String emptyValue = ''}) {
    return _cache.putIfAbsent(format.hashCode ^ emptyValue.hashCode,
            () => FormatTime._(format, emptyValue));
  }

  /// Shorthand to create FormatTime which uses [DateFormat.Hm]
  factory FormatTime.short({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatTime._f(format: DateFormat.Hm(locale), emptyValue: emptyValue);

  /// Shorthand to create FormatTime which uses [DateFormat.Hms]
  factory FormatTime.long({String emptyValue = '', String locale = 'cs_CZ'}) =>
      FormatTime._f(format: DateFormat.Hms(locale), emptyValue: emptyValue);

  FormatTime._(this._format, this.emptyValue);

  /// Formats passed [dateTime] using [format], if null is passed, [emptyValue] is returned.
  ///
  /// e.g.
  /// ```dart
  /// FormatTime.short().format(DateTime.now())
  /// ```
  String format(DateTime? dateTime) => dateTime == null ? emptyValue : _format.format(dateTime);
}

/// Global shorthand to `FormatTime.short().format(DateTime.now())`
String formatTimeShort(DateTime? date) => FormatTime.short().format(date);

/// Global shorthand to `FormatTime.long().format(DateTime.now())`
String formatTimeLong(DateTime? date) => FormatTime.long().format(date);

/// Global shorthand to `FormatTime.short().format(DateTime.now())`. It's same as [formatTimeShort].
String formatTime(DateTime? date) => FormatTime.short().format(date);