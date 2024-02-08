import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';

///
///  DataRangeConverter annotation
///  use with the DataRange members
///  e.g.
///  @JsonKey(name: 'date_range')
///  @DateRangeConverter()
///  DateRange dateRange;
///
class DateRangeConverter implements JsonConverter<DateRange?, String?> {
  const DateRangeConverter();

  @override
  DateRange? fromJson(String? json) {
    return DateRange.parse(json);
  }

  @override
  String? toJson(DateRange? range) {
    return range?.toString();
  }
}

///
///  DataRangesConverter annotation
///  use with the List of DataRange members
///  e.g.
///  @JsonKey(name: 'date_ranges')
///  @DateRangesConverter()
///  List<DateRange> dateRanges;
///
class DateRangesConverter implements JsonConverter<List<DateRange>?, List<String>?> {
  const DateRangesConverter();

  @override
  List<DateRange>? fromJson(List<String>? json) {
    return json?.map((String input) => DateRange.parse(input) ?? DateRange(null, null)).toList();
  }

  @override
  List<String>? toJson(List<DateRange>? ranges) {
    return ranges?.map((DateRange range) => range.toString()).toList();
  }

}
