/*
 * Copyright 2025 Martin Edlman - Anycode <ac@anycode.dev>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:ac_dart/ac_dart.dart';
import 'package:event_bus/event_bus.dart';
import 'package:test/test.dart';

class TestObject {
  final int id;
  final String name;

  TestObject(this.id, this.name);
}

void main() {
  group('EventBus tests', () {
    late EventBus localEventBus;

    setUp(() {
      localEventBus = EventBus();
    });

    test('Test global event bus', () {
      // Check that global instance exists
      expect(eventBus, isA<EventBus>());
    });

    test('Test ObjectCreated event', () async {
      final testObject = TestObject(1, 'Test');
      bool eventReceived = false;

      // Listen for event
      localEventBus.on<ObjectCreated<TestObject>>().listen((event) {
        expect(event.object, equals(testObject));
        eventReceived = true;
      });

      // Fire event
      localEventBus.fireObjectCreated<TestObject>(testObject);

      // Allow processing of async event
      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test ObjectUpdated event', () async {
      final testObject = TestObject(1, 'Test');
      bool eventReceived = false;

      localEventBus.on<ObjectUpdated<TestObject>>().listen((event) {
        expect(event.object, equals(testObject));
        eventReceived = true;
      });

      localEventBus.fireObjectUpdated<TestObject>(testObject);

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test ObjectDeleted event', () async {
      final testObject = TestObject(1, 'Test');
      bool eventReceived = false;

      localEventBus.on<ObjectDeleted<TestObject>>().listen((event) {
        expect(event.object, equals(testObject));
        eventReceived = true;
      });

      localEventBus.fireObjectDeleted<TestObject>(testObject);

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test BusData event', () async {
      const uniqueKey = 'test-key';
      final testData = 'test-data';
      bool eventReceived = false;

      localEventBus.on<BusData<String>>().listen((event) {
        expect(event.uniqueKey, equals(uniqueKey));
        expect(event.data, equals(testData));
        eventReceived = true;
      });

      localEventBus.fireBusData<String>(uniqueKey, testData);

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test BusDataList event', () async {
      const uniqueKey = 'test-list-key';
      final testDataList = [1, 2, 3];
      bool eventReceived = false;

      localEventBus.on<BusDataList<int>>().listen((event) {
        expect(event.uniqueKey, equals(uniqueKey));
        expect(event.data, equals(testDataList));
        eventReceived = true;
      });

      localEventBus.fireBusDataList<int>(uniqueKey, testDataList);

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test BusSignal event', () async {
      const uniqueKey = 123;
      bool eventReceived = false;

      localEventBus.on<BusSignal<String>>().listen((event) {
        expect(event.uniqueKey, equals(uniqueKey));
        eventReceived = true;
      });

      localEventBus.fireBusSignal<String>(uniqueKey);

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Test BusSignal without key', () async {
      bool eventReceived = false;

      localEventBus.on<BusSignal<String>>().listen((event) {
        expect(event.uniqueKey, isNull);
        eventReceived = true;
      });

      localEventBus.fireBusSignal<String>();

      await Future.delayed(Duration.zero);
      expect(eventReceived, isTrue);
    });

    test('Only correct event types are received', () async {
      final testObject = TestObject(1, 'Test');
      bool correctEventReceived = false;
      bool incorrectEventReceived = false;

      // Listen only for TestObject objects
      localEventBus.on<ObjectCreated<TestObject>>().listen((event) {
        correctEventReceived = true;
      });

      // Should not be triggered for other types
      localEventBus.on<ObjectCreated<String>>().listen((event) {
        incorrectEventReceived = true;
      });

      localEventBus.fireObjectCreated<TestObject>(testObject);

      await Future.delayed(Duration.zero);
      expect(correctEventReceived, isTrue);
      expect(incorrectEventReceived, isFalse);
    });
  });
}
