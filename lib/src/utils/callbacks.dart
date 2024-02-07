/// Callback function which takes one argument of type T.
/// It has same signature as Flutter ValueChanged<T> or ValueSetter<T> callbacks
typedef AcValueCallback<T> = void Function(T value);

/// Asynchronous callback function which takes one argument of type T and returns a Future
typedef AcAsyncValueCallback<T> = Future Function(T value);

/// Callback function which takes one argument of type T and returns a value of type R
typedef AcValueTransformerCallback<T, R> = R Function(T value);

/// Asynchronous callback function which takes one argument of type T and returns a Future of type R
typedef AcAsyncValueTransformerCallback<T, R> = Future<R> Function(T value);
