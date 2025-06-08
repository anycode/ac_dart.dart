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

import 'dart:convert';

extension JsonCodecExt on JsonCodec {
  /// Wrapper around [JsonCodec.decode] that parses the bytes array as UTF-8 string
  /// and returns the resulting Json object.
  ///
  /// The optional [reviver] function is called once for each object or list
  /// property that has been parsed during decoding. The `key` argument is either
  /// the integer list index for a list property, the string map key for object
  /// properties, or `null` for the final result.
  ///
  /// The default [reviver] (when not provided) is the identity function.
  dynamic decodeBytes(List<int> bytes, {Object? Function(Object? key, Object? value)? reviver}) {
    return decode(utf8.decode(bytes), reviver: reviver);
  }
}

/// Parses the bytes array as UTF-8 string and returns the resulting Json object.
///
/// The optional [reviver] function is called once for each object or list
/// property that has been parsed during decoding. The `key` argument is either
/// the integer list index for a list property, the string map key for object
/// properties, or `null` for the final result.
///
/// The default [reviver] (when not provided) is the identity function.
///
/// Shorthand for `json.decodeBytes`. Useful if a local variable shadows the global
/// [json] constant.
///
/// see [JsonCodecExt.decodeBytes]
dynamic jsonDecodeBytes(List<int> bytes, {Object? Function(Object? key, Object? value)? reviver}) =>
    json.decodeBytes(bytes, reviver: reviver);
