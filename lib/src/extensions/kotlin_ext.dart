extension TakeIfExt<T> on T? {
  T? takeIf(bool Function(T it) block) {
    if (this != null && block(this!)) {
      return this;
    }
    return null;
  }
}
