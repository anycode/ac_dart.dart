import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';

///
///  Use IntRangeConverter annotation with the IntRange members, e.g.
///  ```dart
///  @JsonKey(name: 'int_range')
///  @IntRangeConverter()
///  IntRange intRange;
///  ```
class IntRangeConverter implements JsonConverter<IntRange, String> {
  const IntRangeConverter();

  /// Converts a JSON string to an [IntRange].
  ///
  /// If the JSON string cannot be parsed, it returns an empty [IntRange] (0, 0).
  @override
  IntRange fromJson(String json) => IntRange.parse(json) ?? IntRange(0, 0);

  /// Converts an [IntRange] to a JSON string.
  ///
  /// The string representation of the [IntRange] is used.
  @override
  String toJson(IntRange range) => range.toString();
}

///
///  Use IntRangesConverter annotation with the List of IntRange members, e.g.
///  ```dart
///  @JsonKey(name: 'int_ranges')
///  @IntRangesConverter()
///  List<IntRange> intRanges;
///  ```
class IntRangesConverter implements JsonConverter<List<IntRange>, List<String>> {
  const IntRangesConverter();

  /// Converts a list of JSON strings to a list of [IntRange]s.
  ///
  /// If a JSON string cannot be parsed, it defaults to an empty [IntRange] (0, 0).
  @override
  List<IntRange> fromJson(List<String> json) => json.map((input) => IntRange.parse(input) ?? IntRange(0, 0)).toList();

  /// Converts a list of [IntRange]s to a list of JSON strings.
  ///
  /// Each [IntRange] is converted to its string representation.
  @override
  List<String> toJson(List<IntRange> ranges) => ranges.map((IntRange range) => range.toString()).toList();
}
