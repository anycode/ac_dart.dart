extension TakeIfExt<T> on T {
  T? takeIf(bool Function(T it) block) {
    return block(this) ? this : null;
  }
}
