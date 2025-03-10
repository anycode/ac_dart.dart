import '../extensions/datetime_ext.dart';
import '../format/format_datetime.dart';

/// Helper function to format date range specified by DateTime objects. If both are the same date,
/// output is formatted as "datetime from - time to". Otherwise, output is formatted as "datetime from - datetime to".
///
/// e.g.
/// ```dart
/// DateTime date1 = DateTime(2025, 1, 1, 10, 0, 0);
/// DateTime date2 = DateTime(2025, 1, 1, 14, 0, 0);
/// DateTime date3 = DateTime(2025, 2, 1, 18, 0, 0);
/// final fmt1 = formatDateTimeRange(date1, date2); // "01.01.2025 10:00 - 14:00"
/// final fmt2 = formatDateTimeRange(date1, date3); // "01.01.2025 10:00 - 01.02.2025 18:00"
/// ```
String formatDateTimeRange(DateTime from, DateTime to) => from.trunc(DateTimeExt.unitDay) == to.trunc(DateTimeExt.unitDay)
    ? '${formatDateTime(from)} - ${formatTime(to)}'
    : '${formatDateTime(from)} - ${formatDateTime(to)}';
