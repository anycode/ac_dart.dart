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

  @override
  List<int> fromPgSql(String hexString) {
    return HEX.decode(hexString.substring(2));
  }

  @override
  String toPgSql(List<int> bytes) {
    return '\\x' + HEX.encode(bytes);
  }
}
