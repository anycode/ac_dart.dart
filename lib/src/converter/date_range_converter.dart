import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
/// [DateRangeConverter] is a [JsonConverter] and [PgSqlConverter] that handles
/// the conversion of [DateRange] objects to and from their string representations.
///
/// It is designed to be used with the `@JsonKey` annotation to specify the
/// name of the JSON field and the `@DateRangeConverter` annotation to indicate
/// that this converter should be used for the field.
///
/// Example usage:
///  ```dart
///  @JsonKey(name: 'date_range')
///  @DateRangeConverter()
///  DateRange dateRange;
///  ```
///
/// Can be used as standalone converter, not only via the annotation, e.g.
/// ```dart
/// final dr = const DateRangeConvertor().fromJson(json);
/// ```
class DateRangeConverter implements JsonConverter<DateRange, String>, PgSqlConverter<DateRange, String> {
  /// Creates a [DateRangeConverter] instance.
  const DateRangeConverter();

  /// Converts a JSON string to a [DateRange] object.
  ///
  /// If the input string is not a valid [DateRange] representation, it returns
  /// an infinite [DateRange] (-infinity, infinity)
  @override
  DateRange fromJson(String json) => DateRange.parse(json) ?? DateRange(null, null);

  /// Converts a [DateRange] object to its string representation.
  @override
  String toJson(DateRange range) => range.toString();

  /// Converts a PostgreSQL string to a [DateRange] object.
  ///
  /// This method is equivalent to [fromJson].
  @override
  DateRange fromPgSql(String text) => fromJson(text);

  /// Converts a [DateRange] object to its PostgreSQL string representation.
  ///
  /// This method is equivalent to [toJson].
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
  /// Creates a [DateRangesConverter] instance.
  const DateRangesConverter();

  /// Converts a list of JSON strings to a list of [DateRange] objects.
  ///
  /// If any of the input strings are not valid [DateRange] representations,
  /// they are converted to an infinite [DateRange].
  @override
  List<DateRange> fromJson(List<String> json) => json.map((String input) => DateRange.parse(input) ?? DateRange(null, null)).toList();

  /// Converts a list of [DateRange] objects to a list of their string
  /// representations.
  @override
  List<String> toJson(List<DateRange> ranges) => ranges.map((DateRange range) => range.toString()).toList();

  /// Converts a list of PostgreSQL strings to a list of [DateRange] objects.
  ///
  /// This method is equivalent to [fromJson].
  @override
  List<DateRange> fromPgSql(List<String> ranges) => fromJson(ranges);

  /// Converts a list of [DateRange] objects to a list of their PostgreSQL
  /// string representations.
  ///
  /// This method is equivalent to [toJson].
  @override
  List<String> toPgSql(List<DateRange> ranges) => toJson(ranges);
}
