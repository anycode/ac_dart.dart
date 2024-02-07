import 'package:json_annotation/json_annotation.dart';
import 'package:ranges/ranges.dart';

///
///  DoubleRangeConverter annotation
///  use with the DoubleRange members
///  e.g.
///  @JsonKey(name: 'double_range')
///  @DoubleRangeConverter()
///  DoubleRange doubleRange;
///
class DoubleRangeConverter implements JsonConverter<DoubleRange?, String?> {
  const DoubleRangeConverter();

  @override
  DoubleRange? fromJson(String? json) {
    return DoubleRange.parse(json);
  }

  @override
  String? toJson(DoubleRange? range) {
    return range?.toString();
  }
}

///
///  DoubleRangesConverter annotation
///  use with the List of DoubleRange members
///  e.g.
///  @JsonKey(name: 'double_ranges')
///  @DoubleRangesConverter()
///  List<DoubleRange> doubleRanges;
///
class DoubleRangesConverter implements JsonConverter<List<DoubleRange>?, List<String>?> {
  const DoubleRangesConverter();

  @override
  List<DoubleRange>? fromJson(List<String>? json) {
    return json?.map((input) => DoubleRange.parse(input) ?? DoubleRange(0.0, 0.0)).toList();
  }

  @override
  List<String>? toJson(List<DoubleRange>? ranges) {
    return ranges?.map((DoubleRange range) => range.toString()).toList();
  }
}
