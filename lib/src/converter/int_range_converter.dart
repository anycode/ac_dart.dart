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

  @override
  IntRange fromJson(String json) {
    return IntRange.parse(json) ?? IntRange(0, 0);
  }

  @override
  String toJson(IntRange range) {
    return range.toString();
  }
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

  @override
  List<IntRange> fromJson(List<String> json) {
    return json.map((input) => IntRange.parse(input) ?? IntRange(0, 0)).toList();
  }

  @override
  List<String> toJson(List<IntRange> ranges) {
    return ranges.map((IntRange range) => range.toString()).toList();
  }
}
