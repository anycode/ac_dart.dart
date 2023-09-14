import '../utils/format.dart' as fmt;

extension NumExt on num {
  String format([int decimal = 2]) => fmt.formatNumber(this, decimal);
  String formatCsv() => fmt.formatCsvNumber(this);
  String formatPrice() => fmt.formatPrice(this);
  String formatCsvPrice() => fmt.formatCsvPrice(this);
  String formatDistance({String unit = 'm', double modulo = 1.0, int decimal = 2}) =>
      fmt.formatDistance(this, unit: unit, modulo: modulo, decimal: decimal);
}
