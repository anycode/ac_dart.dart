extension DateTimeExt on DateTime {
/*
  Available in DartSDK since 2.19
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
*/

  /// Returns a new [DateTime] with the specified [time]
  DateTime withTime(DateTime time) => DateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
  /// Returns a new [DateTime] with the specified [date]
  DateTime withDate(DateTime date) => DateTime(date.year, date.month, date.day, hour, minute, second, millisecond, microsecond);

  /// Returns number of quarter based on month. Months Jan-Mar = 1, Apr-Jun = 2, Jul-Sep = 3, Oct-Dec = 4
  /// Pozn: pokud je rozsireni povoleny, generuje se chybne kod pro JSON serializaci
  /// pouzivajici @DateTimeConverter. Generovany kod nevola konvertor
  int get quarter => month <= 3 ? 1 : month <= 6 ? 2 : month <= 9 ? 3 : month <= 12 ? 4 : -1;

  // prozatim pouzivam funkci pro ziskani ctvrtleti
  int getQuarter() => month <= 3 ? 1 : month <= 6 ? 2 : month <= 9 ? 3 : month <= 12 ? 4 : -1;

  DateTime dateTimeMonth(DateTime date) => DateTime(date.year, date.month);
  /// Constant unit used to trunc date to years
  static const String unitYear = 'year';
  /// Constant unit used to trunc date to quarters
  static const String unitQuarter = 'quarter';
  /// Constant unit used to trunc date to months
  static const String unitMonth = 'month';
  /// Constant unit used to trunc date to days
  static const String unitDay = 'day';
  /// Constant unit used to trunc date to hours
  static const String unitHour = 'hour';
  /// Constant unit used to trunc date to minutes
  static const String unitMinute = 'minute';
  /// Constant unit used to trunc date to seconds
  static const String unitSecond = 'second';

  /// Returns a new [DateTime] truncated to specified unit
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

  /// Returns string representation in ISO8601 format with time zone offset
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
