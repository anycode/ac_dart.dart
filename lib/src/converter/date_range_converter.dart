import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
///  Use DataRangeConverter annotation with the DataRange members, e.g.
///  ```dart
///  @JsonKey(name: 'date_range')
///  @DateRangeConverter()
///  DateRange dateRange;
///  ```
class DateRangeConverter implements JsonConverter<DateRange, String>, PgSqlConverter<DateRange, String> {
  const DateRangeConverter();

  @override
  DateRange fromJson(String json) => DateRange.parse(json) ?? DateRange(null, null);

  @override
  String toJson(DateRange range) => range.toString();

  @override
  DateRange fromPgSql(String text) => fromJson(text);

  @override
  String toPgSql(DateRange range) => toJson(range);
}

///
///  Use DataRangesConverter annotation with the List of DataRange members, e.g.
///  ```dart
///  @JsonKey(name: 'date_ranges')
///  @DateRangesConverter()
///  List<DateRange> dateRanges;
///  ```
class DateRangesConverter implements JsonConverter<List<DateRange>, List<String>>, PgSqlConverter<List<DateRange>, List<String>> {
  const DateRangesConverter();

  @override
  List<DateRange> fromJson(List<String> json) {
    return json.map((String input) => DateRange.parse(input) ?? DateRange(null, null)).toList();
  }

  @override
  List<String> toJson(List<DateRange> ranges) {
    return ranges.map((DateRange range) => range.toString()).toList();
  }

  @override
  List<DateRange> fromPgSql(List<String> ranges) {
    return fromJson(ranges);
  }

  @override
  List<String> toPgSql(List<DateRange> ranges) {
    return toJson(ranges);
  }
}
