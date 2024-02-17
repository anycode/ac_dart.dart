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
