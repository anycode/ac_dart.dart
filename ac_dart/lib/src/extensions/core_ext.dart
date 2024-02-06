extension AsOptionalExt on Object {
  X? asOrNull<X>() {
    var self = this;
    return self is X ? self as X : null;
  }
}
