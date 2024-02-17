import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';

///
///  Use DoubleRangeConverter annotation with the DoubleRange members, e.g.
///  ```
///  @JsonKey(name: 'double_range')
///  @DoubleRangeConverter()
///  DoubleRange doubleRange;
///  ```
///
class DoubleRangeConverter implements JsonConverter<DoubleRange, String> {
  /// Const Constructor for DoubleRangeConverter
  const DoubleRangeConverter();

  @override
  DoubleRange fromJson(String json) => DoubleRange.parse(json) ?? DoubleRange(0.0, 0.0);

  @override
  String toJson(DoubleRange range) => range.toString();
}

///
///  Use DoubleRangesConverter annotation with the List of DoubleRange members, e.g.
///  ```dart
///  @JsonKey(name: 'double_ranges')
///  @DoubleRangesConverter()
///  List<DoubleRange> doubleRanges;
///  ```
class DoubleRangesConverter implements JsonConverter<List<DoubleRange>, List<String>> {
  /// Const constructor for DoubleRangesConverter
  const DoubleRangesConverter();

  @override
  List<DoubleRange> fromJson(List<String> json) {
    return json.map((input) => DoubleRange.parse(input) ?? DoubleRange(0.0, 0.0)).toList();
  }

  @override
  List<String> toJson(List<DoubleRange> ranges) {
    return ranges.map((DoubleRange range) => range.toString()).toList();
  }
}
