extension AsOptionalExt on Object {
  /// Returns `this` as instance of `X` if it is an instance of `X`, `null` otherwise
  X? asOrNull<X>() {
    var self = this;
    return self is X ? self as X : null;
  }
}
