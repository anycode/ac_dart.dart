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
