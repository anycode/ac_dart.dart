extension StringValidatorExt on String {
  /// Capitalizes the first letter of the string
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';

  /// Tests whether the string is valid email address
  bool get isEmail => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}
