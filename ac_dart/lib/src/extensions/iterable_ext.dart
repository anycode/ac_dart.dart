extension IterableSorted<T> on Iterable<T> {
  Iterable<T> sorted([int Function(T a, T b)? compare]) => [...this]..sort(compare);
}