import '../extensions/datetime_ext.dart';
import '../format/format_datetime.dart';

String formatDateTimeRange(DateTime from, DateTime to) => from.trunc(DateTimeExt.unitDay) == to.trunc(DateTimeExt.unitDay)
    ? '${formatDateTime(from)} - ${formatTime(to)}'
    : '${formatDateTime(from)} - ${formatDateTime(to)}';
