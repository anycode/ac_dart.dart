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

extension EventBusExt on EventBus {
  fireObjectCreated<T>(T object) => fire(ObjectCreated(object));
  fireObjectUpdated<T>(T object) => fire(ObjectUpdated(object));
  fireObjectDeleted<T>(T object) => fire(ObjectDeleted(object));
  fireBusData<T>(String uniqueKey, T data) => fire(BusData(uniqueKey, data));
  fireBusDataList<T>(String uniqueKey, List<T> data) => fire(BusDataList(uniqueKey, data));
  fireBusSignal<T>([int? uniqueKey]) => fire(BusSignal<T>(uniqueKey));

  void onObjectCreated<T>() => on<ObjectCreated<T>>();
  void onObjectUpdated<T>() => on<ObjectUpdated<T>>();
  void onObjectDeleted<T>() => on<ObjectDeleted<T>>();
  void onBusData<T>() => on<BusData<T>>();
  void onBusDataList<T>() => on<BusDataList<T>>();
  void onBusSignal<T>() => on<BusSignal<T>>();
}
