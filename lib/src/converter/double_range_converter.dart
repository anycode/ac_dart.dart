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

  /// Convert string to range of doubles. If string cannot be parsed, returns empty range
  /// of (0.0, 0.0)
  @override
  DoubleRange fromJson(String json) => DoubleRange.parse(json) ?? DoubleRange(0.0, 0.0);

  /// Convert range of doubles to string representation.
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

  /// Convert list of strings to [List<DoubleRange>].
  ///
  /// If any value cannot be parsed, returns empty range of (0.0, 0.0) for that value.
  @override
  List<DoubleRange> fromJson(List<String> json) => json.map((input) => DoubleRange.parse(input) ?? DoubleRange(0.0, 0.0)).toList();


  /// Convert list of [DoubleRange] to list of strings.
  @override
  List<String> toJson(List<DoubleRange> ranges) => ranges.map((DoubleRange range) => range.toString()).toList();
}
