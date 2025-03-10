import 'package:event_bus/event_bus.dart';

/// Global event bus for general purpose.
final eventBus = EventBus();

/// Event bus message to notify that new object of T was created.
class ObjectCreated<T> {
  final T object;
  ObjectCreated(this.object);
}

/// Event bus message to notify that object of T was updated.
class ObjectUpdated<T> {
  final T object;
  ObjectUpdated(this.object);
}

/// Event bus message to notify that object of T was deleted.
class ObjectDeleted<T> {
  final T object;
  ObjectDeleted(this.object);
}

/// Event bus message to notify the [data], identified by unique key
class BusData<T> {
  String uniqueKey;
  T data;
  BusData(this.uniqueKey, this.data);
}

/// Event bus message to notify the list of [data], identified by unique key
class BusDataList<T> extends BusData<List<T>> {
  BusDataList(super.uniqueKey, super.payload);
}

/// Event bus signal to notify that some event of type T identified
/// by optional unique key occurred
class BusSignal<T> {
  int? uniqueKey;
  BusSignal([this.uniqueKey]);
}

/// Extension on [EventBus] to provide convenient methods for firing and listening to events.
extension EventBusExt on EventBus {
  /// Fires an [ObjectCreated] event with the given [object].
  ///
  /// This method is a convenience wrapper around `fire(ObjectCreated(object))`.
  fireObjectCreated<T>(T object) => fire(ObjectCreated(object));

  /// Fires an [ObjectUpdated] event with the given [object].
  ///
  /// This method is a convenience wrapper around `fire(ObjectUpdated(object))`.
  fireObjectUpdated<T>(T object) => fire(ObjectUpdated(object));

  /// Fires an [ObjectDeleted] event with the given [object].
  ///
  /// This method is a convenience wrapper around `fire(ObjectDeleted(object))`.
  fireObjectDeleted<T>(T object) => fire(ObjectDeleted(object));

  /// Fires a [BusData] event with the given [uniqueKey] and [data].
  ///
  /// This method is a convenience wrapper around `fire(BusData(uniqueKey, data))`.
  fireBusData<T>(String uniqueKey, T data) => fire(BusData(uniqueKey, data));

  /// Fires a [BusDataList] event with the given [uniqueKey] and [data].
  ///
  /// This method is a convenience wrapper around `fire(BusDataList(uniqueKey, data))`.
  fireBusDataList<T>(String uniqueKey, List<T> data) => fire(BusDataList(uniqueKey, data));

  /// Fires a [BusSignal] event with the given optional [uniqueKey].
  ///
  /// This method is a convenience wrapper around `fire(BusSignal<T>(uniqueKey))`.
  fireBusSignal<T>([int? uniqueKey]) => fire(BusSignal<T>(uniqueKey));

  /// Returns a stream of [ObjectCreated] events.
  ///
  /// This method is a convenience wrapper around `on<ObjectCreated<T>>()`.
  void onObjectCreated<T>() => on<ObjectCreated<T>>();

  /// Returns a stream of [ObjectUpdated] events.
  ///
  /// This method is a convenience wrapper around `on<ObjectUpdated<T>>()`.
  void onObjectUpdated<T>() => on<ObjectUpdated<T>>();

  /// Returns a stream of [ObjectDeleted] events.
  ///
  /// This method is a convenience wrapper around `on<ObjectDeleted<T>>()`.
  void onObjectDeleted<T>() => on<ObjectDeleted<T>>();

  /// Returns a stream of [BusData] events.
  ///
  /// This method is a convenience wrapper around `on<BusData<T>>()`.
  void onBusData<T>() => on<BusData<T>>();

  /// Returns a stream of [BusDataList] events.
  ///
  /// This method is a convenience wrapper around `on<BusDataList<T>>()`.
  void onBusDataList<T>() => on<BusDataList<T>>();

  /// Returns a stream of [BusSignal] events.
  ///
  /// This method is a convenience wrapper around `on<BusSignal<T>>()`.
  void onBusSignal<T>() => on<BusSignal<T>>();
}
