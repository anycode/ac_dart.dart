import 'package:pgsql_annotation/pgsql_annotation.dart';

///
///  NumericConverter annotation
///  Converter for Postgres SQL numeric values
///  It's handy when processing JSON-like Map where Numeric is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'number')
///  @NumericConverter()
///  Numeric date;
///
class NumericConverter implements PgSqlConverter<double, Object> {
  const NumericConverter();

  @override
  double fromPgSql(Object json) {
    if (json is num) {
      return json as double;
    } else if (json is String) {
      return double.tryParse(json) ?? 0.0;
    } else {
      throw Exception('Invalid input for numeric');
    }
  }

  @override
  String toPgSql(double number) => number.toString();
}

///
///  NumericListConverter annotation
///  If the Numeric is already of Numeric type return it, otherwise try to parse String.
///  It's handy when processing JSON-like Map where Numeric is already preprocessed by caller (e.g. database driver)
///  e.g.
///  @JsonKey(name: 'dates')
///  @NumericConverter()
///  List<Numeric> dates;
///
class NumericListConverter implements PgSqlConverter<List<double>, List<Object>> {
  const NumericListConverter();

  @override
  List<double> fromPgSql(List<Object> json) {
    const nc = NumericConverter();
    return json.map((input) => nc.fromPgSql(input)).toList();
  }

  @override
  List<String> toPgSql(List<double> numbers) {
    const nc = NumericConverter();
    return numbers.map((number) => nc.toPgSql(number)).toList();
  }
}
