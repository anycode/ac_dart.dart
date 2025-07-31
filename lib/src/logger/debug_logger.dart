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

import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import 'ac_logger.dart';

/// Debugging logger which logs events to console and multiple (rotated) files.
/// A logger must have a name and optional ID.
/// If `output` is not provided, all loggers with same name share the same output.
/// If `printer` is not provided, `id` is used as a prefix for each line of DebugPrinter().
class DebugLogger extends AcLogger {
  /// List of [AdvancedFileOutput] outputs
  /// All debug loggers with same name share the same output
  static final _fileOutputs = <String, AdvancedFileOutput>{};

  /// List of [StreamOutput] outputs
  /// All debug loggers with same name share the same stream output
  static final _streamOutputs = <String, StreamOutput>{};

  /// Creates/returns a single logger with given [name]. Optionally, a [level], a multi file [fileOutput],
  /// a [filter] and a [printer] can be provided.
  ///
  /// If you need multiple instances, use [DebugLogger.instantiate()] constructor.
  factory DebugLogger({
    required String name,
    String? id,
    Level? level,
    AdvancedFileOutput? fileOutput,
    LogFilter? filter,
    LogPrinter? printer,
  }) => AcLogger.singleton(
    name,
    () => DebugLogger.instantiate(
      name: name,
      id: id,
      level: level,
      fileOutput: fileOutput,
      useConsoleOutput: true,
      filter: filter,
      printer: printer,
    ),
  );

  /// Creates/returns a single logger with given name. The output is only to files, not on console.
  /// Optionally, a [level], a [filter] and a [printer] can be provided.
  ///
  /// If you need multiple instances, use [DebugLogger.instantiate(output: MultiFileOutput()] constructor.
  factory DebugLogger.files({
    required String name,
    String? id,
    Level? level,
    required AdvancedFileOutput fileOutput,
    LogFilter? filter,
    LogPrinter? printer,
  }) => AcLogger.singleton(
    name,
    () => DebugLogger.instantiate(
      name: name,
      id: id,
      level: level,
      filter: filter,
      printer: printer,
      fileOutput: fileOutput,
      useConsoleOutput: false,
    ),
  );

  /// Creates/returns a single logger with given name. The output is only on console, not to file(s).
  /// Optionally, a [level], a [filter] and a [printer] can be provided.
  ///
  /// If you need multiple instances, use [DebugLogger.instantiate(output: ConsoleOutput())] constructor.
  factory DebugLogger.console({
    required String name,
    String? id,
    Level? level,
    LogFilter? filter,
    LogPrinter? printer,
  }) {
    return AcLogger.singleton(
      name,
      () => DebugLogger.instantiate(
        name: name,
        id: id,
        level: level,
        filter: filter,
        printer: printer,
        fileOutput: null,
        useConsoleOutput: true,
      ),
    );
  }

  /// Creates new instance of [DebugLogger]. Each call creates new instance, even if name is the same.
  /// If you need single instance, use [DebugLogger()] factory constructor.
  ///
  /// When [fileOutput] is not specified, [MultiOutput] is used by default, which will output to
  /// files and to console. If you want to output to files only, and don't want to provide own [fileOutput],
  /// set [useConsoleOutput] to false. If [fileOutput] is provided, value of [useConsoleOutput] is ignored
  /// and it's caller's decision what the [fileOutput] is.
  DebugLogger.instantiate({
    required super.name,
    String? id,
    super.level,
    AdvancedFileOutput? fileOutput,
    LogFilter? filter,
    LogPrinter? printer,
    bool useConsoleOutput = true,
  }) : super.instantiate(
         output: MultiOutput([
           if (fileOutput != null) _fileOutputs.putIfAbsent(name, () => fileOutput),
           _streamOutputs.putIfAbsent(name, () => StreamOutput()),
           if (useConsoleOutput) ConsoleOutput(),
         ]),
         filter: filter ?? ProductionFilter(),
         printer: printer ?? DebugPrinter(prefix: id),
       );

  AdvancedFileOutput? get output => _fileOutputs[name];

  Stream<String>? get stream => ConcatStream<String>([
    //?_fileOutputs[name]?.stream,
    ?_streamOutputs[name]?.stream.expand((line) => line),
  ]);
}

/// Default [LogPrinter] for [DebugLogger]
class DebugPrinter extends LogPrinter {
  final String _prefix;

  DebugPrinter({String? prefix}) : _prefix = prefix != null ? '$prefix | ' : '';

  @override
  List<String> log(LogEvent event) {
    return [
      ...stringifyMessage(event.message).split('\n').map((line) => '$_prefix${event.time} | ${event.level.name} | $line'),
      if (event.error != null) '$_prefix${event.time} | ${event.level.name} | error:',
      if (event.error != null) ...event.error.toString().split('\n').map((line) => '$_prefix${event.time} | ${event.level.name} |   $line'),
      if (event.stackTrace != null) '$_prefix${event.time} | ${event.level.name} | stack trace:',
      if (event.stackTrace != null)
        ...event.stackTrace.toString().split('\n').map((line) => '$_prefix${event.time} | ${event.level.name} |   $line'),
    ];
  }

  // Handles any object that is causing JsonEncoder() problems
  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
