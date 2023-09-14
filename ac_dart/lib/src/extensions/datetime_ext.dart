extension DateTimeExt on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  DateTime withTime(DateTime time) => DateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
  DateTime withDate(DateTime date) => DateTime(date.year, date.month, date.day, hour, minute, second, millisecond, microsecond);

  int get quarter => month <= 3
      ? 1
      : month <= 6
          ? 2
          : month <= 9
              ? 3
              : month <= 12
                  ? 4
                  : -1;

  static const String unitYear = 'year';
  static const String unitQuarter = 'quarter';
  static const String unitMonth = 'month';
  static const String unitDay = 'day';
  static const String unitHour = 'hour';
  static const String unitMinute = 'minute';
  static const String unitSecond = 'second';

  DateTime trunc(String unit) {
    if (unit == unitYear) {
      return isUtc ? DateTime.utc(year) : DateTime(year);
    }
    if (unit == unitQuarter) {
      return isUtc ? DateTime.utc(year, (quarter - 1) * 3 + 1) : DateTime(year, (quarter - 1) * 3 + 1);
    }
    if (unit == unitMonth) {
      return isUtc ? DateTime.utc(year, month) : DateTime(year, month);
    }
    if (unit == unitDay) {
      return isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);
    }
    if (unit == unitHour) {
      return isUtc ? DateTime.utc(year, month, day, hour) : DateTime(year, month, day, hour);
    }
    if (unit == unitMinute) {
      return isUtc ? DateTime.utc(year, month, day, hour, minute) : DateTime(year, month, day, hour, minute);
    }
    if (unit == unitSecond) {
      return isUtc ? DateTime.utc(year, month, day, hour, minute, second) : DateTime(year, month, day, hour, minute, second);
    }
    return this;
  }

  String toIso8601StringTZD() {
    final result = toIso8601String();
    if (isUtc) return result;
    final ofX = timeZoneOffset.isNegative ? '-' : '+';
    final ofH = _twoDigits(timeZoneOffset.inHours);
    final ofM = _twoDigits(timeZoneOffset.inMinutes % 60);
    return '$result$ofX$ofH:$ofM';
  }

  static String _twoDigits(int n) {
    return (n >= 10) ? '$n' : '0$n';
  }
}
