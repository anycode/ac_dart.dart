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

  ///
  /// Converts a [json] object from PgSql to a double.
  ///
  /// If [json] is a num, it's cast to double.
  /// If [json] is a String, it's parsed to double. if it's not possible to parse the input, returns 0.0.
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

  ///
  /// Converts a [number] double to a String for PgSql.
  ///
  /// It simply calls toString() on the double.
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

  ///
  /// Converts a [json] list of objects from PgSql to a list of doubles.
  ///
  /// Each element in [json] is converted using [NumericConverter.fromPgSql].
  @override
  List<double> fromPgSql(List<Object> json) {
    const nc = NumericConverter();
    return json.map((input) => nc.fromPgSql(input)).toList();
  }

  ///
  /// Converts a [numbers] list of doubles to a list of Strings for PgSql.
  ///
  /// Each number in [numbers] is converted using [NumericConverter.toPgSql].
  @override
  List<String> toPgSql(List<double> numbers) {
    const nc = NumericConverter();
    return numbers.map((number) => nc.toPgSql(number)).toList();
  }
}
