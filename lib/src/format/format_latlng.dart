class _FormatLL {

  final String emptyValue;
  _FormatLL(this.emptyValue);

  String _formatDeg(double ll, int decimal) {
    final deg = ll.abs();
    return '${deg.toStringAsFixed(decimal)}°';
  }

  String _formatDegMin(double ll, int decimal) {
    final value = ll.abs();
    final deg = value.floor();
    final min = ((value - deg) * 60);
    return '$deg°${min.toStringAsFixed(decimal)}\'';
  }

  String _formatDegMinSec(double ll, int decimal) {
    final value = ll.abs();
    final deg = value.floor();
    final min = ((value - deg) * 60).floor();
    final sec = (((value - deg) * 60 - min) * 60);
    return '$deg°$min\'${sec.toStringAsFixed(decimal)}"';
  }
}

class FormatLatitude extends _FormatLL {

  static final _cache = <int, FormatLatitude>{};

  factory FormatLatitude({String emptyValue = ''}) {
    return _cache.putIfAbsent(emptyValue.hashCode, () => FormatLatitude._(emptyValue));
  }

  FormatLatitude._(super.emptyValue);

  formatD(double? lat, {int decimalDigits = 6}) => lat == null ? emptyValue : '${_formatDeg(lat, decimalDigits)}${lat < 0 ? 'S' : 'N'}';
  formatDM(double? lat, {int decimalDigits = 4}) => lat == null ? emptyValue : '${_formatDegMin(lat, decimalDigits)}${lat < 0 ? 'S' : 'N'}';
  formatDMS(double? lat, {int decimalDigits = 3}) => lat == null ? emptyValue : '${_formatDegMinSec(lat, decimalDigits)}${lat < 0 ? 'S' : 'N'}';
}

class FormatLongitude extends _FormatLL {
  static final _cache = <int, FormatLongitude>{};

  factory FormatLongitude({String emptyValue = ''}) {
    return _cache.putIfAbsent(emptyValue.hashCode, () => FormatLongitude._(emptyValue));
  }

  FormatLongitude._(super.emptyValue);

  formatD(double? lng, {int decimalDigits = 6}) => lng == null ? emptyValue : '${_formatDeg(lng, decimalDigits)}${lng < 0 ? 'W' : 'E'}';
  formatDM(double? lng, {int decimalDigits = 4}) => lng == null ? emptyValue : '${_formatDegMin(lng, decimalDigits)}${lng < 0 ? 'W' : 'E'}';
  formatDMS(double? lng, {int decimalDigits = 3}) => lng == null ? emptyValue : '${_formatDegMinSec(lng, decimalDigits)}${lng < 0 ? 'W' : 'E'}';
}

/// Global shorthand to `FormatLatitude({emptyValue: ''}).formatDMS(num? latitude, decimal: int)`
///
/// Format a number as Geo latitude, positive values on northern hemisphere, negative on southern hemisphere, e.g.
/// ```dart
/// formatLatitude(45.569) => 45°34'8.4"N
/// formatLatitude(-45.569) => 45°34'8.4"S
/// ```
String formatLatitude(double lat) => FormatLatitude().formatDMS(lat);

/// Global shorthand to `FormatLongitude({emptyValue: ''}).formatDMS(num? longitude, decimal: int)`
///
/// Format a number as Geo longitude, positive values on eastern hemisphere, negative on western hemisphere, e.g.
/// ```dart
/// formatLongitude(45.569) => 45°34'8.4"E
/// formatLongitude(-45.569) => 45°34'8.4"W
/// ```
String formatLongitude(double lng) => FormatLongitude().formatDMS(lng);

/// Global shorthand to `formatLatitude(double lat), formatLongitude(double lng)`
///
/// Format a number as Geo latitude and longitude, e.g.
/// ```dart
/// formatLatLng(45.569, 12.345) => 45°34'8.4"N, 12°20'42.0"E
/// formatLatLng(-45.569, -12.345) => 45°34'8.4"S, 12°20'42.0"W
/// ```
String formatLatLng(double lat, double lng) => '${formatLatitude(lat)}, ${formatLongitude(lng)}';
