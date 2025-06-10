/*
 * Copyright 2025 Martin Edlman - Anycode <ac@anycode.dev>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:ac_ranges/ac_ranges.dart';

///
/// [DateRangeConverter] is a [JsonConverter] that handles
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
class DateRangeConverter implements JsonConverter<DateRange, String> {
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
}

///
///  Use DataRangesConverter annotation with the List of DataRange members, e.g.
///  ```dart
///  @JsonKey(name: 'date_ranges')
///  @DateRangesConverter()
///  List<DateRange> dateRanges;
///  ```
class DateRangesConverter implements JsonConverter<List<DateRange>, List<String>> {
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
}
