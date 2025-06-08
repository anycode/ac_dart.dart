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

import 'package:hex/hex.dart';
import 'package:pgsql_annotation/pgsql_annotation.dart';

///
///  HexConverter annotation
///  Converts List<int> bytes to/from String suitable for PgSql bytea
///  @PgSqlKey(name: 'bytes')
///  @DateTimeConverter()
///  DateTime date;
///
class HexConverter implements PgSqlConverter<List<int>, String> {
  const HexConverter();

  /// Convert string encoded bytes to list of bytes.
  @override
  List<int> fromPgSql(String hexString) => HEX.decode(hexString.substring(2));

  /// Convert list of bytes to string encoded representation.
  @override
  String toPgSql(List<int> bytes) => '\\x${HEX.encode(bytes)}';
}
