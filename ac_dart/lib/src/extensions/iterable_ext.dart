extension IterableSorted<T> on Iterable<T> {
  Iterable<T> sorted([int compare(T a, T b)?]) => [...this]..sort(compare);
}