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
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

import 'ac_logger.dart';

/// Debugging logger which logs events to console and multiple (rotated) files.
/// A logger must have a name and optional ID.
/// If `output` is not provided, all loggers with same name share the same output.
/// If `printer` is not provided, `id` is used as a prefix for each line of DebugPrinter().
class DebugLogger extends AcLogger {
  /// List of [MultiFileOutput] outputs
  /// All debug loggers with same name share the same output
  static final _fileOutputs = <String, MultiFileOutput>{};

  /// List of [StreamOutput] outputs
  /// All debug loggers with same name share the same stream output
  static final _streamOutputs = <String, StreamOutput>{};

  /// Creates/returns a single logger with given [name]. Optionally, a [level], a multi file [output],
  /// a [filter] and a [printer] can be provided.
  ///
  /// If you need multiple instances, use [DebugLogger.instantiate()] constructor.
  factory DebugLogger({
    required String name,
    String? id,
    Level? level,
    MultiFileOutput? output,
    LogFilter? filter,
    LogPrinter? printer,
  }) =>
      AcLogger.singleton(
        name,
        () => DebugLogger.instantiate(
          name: name,
          id: id,
          level: level,
          output: MultiOutput([
            _fileOutputs.putIfAbsent(name, () => output ?? MultiFileOutput(file: File('logs/$name.log'), maxSize: 100)),
            _streamOutputs.putIfAbsent(name, () => StreamOutput()),
            ConsoleOutput(),
          ]),
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
    MultiFileOutput? output,
    LogFilter? filter,
    LogPrinter? printer,
  }) =>
      AcLogger.singleton(
        name,
        () => DebugLogger.instantiate(
          name: name,
          id: id,
          level: level,
          filter: filter,
          printer: printer,
          output: MultiOutput([
            _fileOutputs.putIfAbsent(name, () => output ?? MultiFileOutput(file: File('logs/$name.log'), maxSize: 100)),
            _streamOutputs.putIfAbsent(name, () => StreamOutput()),
          ]),
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
        output: MultiOutput([
          ConsoleOutput(),
          _streamOutputs.putIfAbsent(name, () => StreamOutput()),
        ]),
      ),
    );
  }

  /// Creates new instance of [DebugLogger]. Each call creates new instance, even if name is the same.
  /// If you need single instance, use [DebugLogger()] factory constructor.
  ///
  /// When [output] is not specified, [MultiOutput] is used by default, which will output to
  /// files and to console. If you want to output to files only, and don't want to provide own [output],
  /// set [useConsoleOutput] to false. If [output] is provided, value of [useConsoleOutput] is ignored
  /// and it's caller's decision what the [output] is.
  DebugLogger.instantiate({
    required super.name,
    String? id,
    super.level,
    LogOutput? output,
    LogFilter? filter,
    LogPrinter? printer,
    bool useConsoleOutput = true,
  }) : super.instantiate(
          output: output ??
              MultiOutput([
                _fileOutputs.putIfAbsent(name, () => MultiFileOutput(file: File('logs/$name.log'), maxSize: 100)),
                _streamOutputs.putIfAbsent(name, () => StreamOutput()),
                if (useConsoleOutput) ConsoleOutput(),
              ]),
          filter: filter ?? ProductionFilter(),
          printer: printer ?? DebugPrinter(prefix: id),
        );

  MultiFileOutput? get output => _fileOutputs[name];
  Stream<String>? get stream => ConcatStream<String>([
        ?_fileOutputs[name]?.stream,
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

/// Default [FileOutput] for [DebugLogger]
class MultiFileOutput extends FileOutput {
  static const defaultMaxSize = 2 * 1024 * 1024; // 2 MB
  static const defaultMaxFiles = 10;

  final int maxFiles;
  final int maxSize;
  final File file;
  final List<File> _files = [];
  final Lock _rotationLock = Lock();

  MultiFileOutput({
    required this.file,
    super.overrideExisting = false,
    super.encoding = utf8,
    this.maxFiles = defaultMaxFiles,
    this.maxSize = defaultMaxSize,
  }) : super(file: file) {
    _init();
  }

  void _init() {
    final base = path.basenameWithoutExtension(file.path);
    final ext = path.extension(file.path);
    final dir = path.dirname(file.path);
    _files.clear();
    if (maxFiles > 0) {
      for (int i = 0; i < maxFiles; i++) {
        final filename = '$dir/$base.$i$ext';
        _files.add(File(filename));
      }
    }
  }

  List<File> get files => _files;

  List<XFile> get xFiles => _files.map((f) => XFile(f.path)).toList();

  void clearLog() {
    for (final f in _files) {
      if (f.existsSync() == true) {
        f.deleteSync();
      }
    }
    if (file.existsSync()) {
      file.deleteSync();
    }
    file.createSync();
    _init();
  }

  @override
  void output(OutputEvent event) {
    _rotationLock.synchronized(() async {
      super.output(event);

      // rollover if needed
      var fileSize = file.existsSync() ? file.lengthSync() : 0;
      if (fileSize <= maxSize) {
        return;
      }

      for (int i = maxFiles - 1; i > 0; i--) {
        var fileA = _files[i];
        var fileB = _files[i - 1];
        if (fileA.existsSync()) {
          fileA.deleteSync();
        }
        if (fileB.existsSync()) {
          fileB.renameSync(fileA.path);
        }
      }
      if (file.existsSync()) {
        await super.destroy();
        file.renameSync(_files[0].path);
      }
      file.createSync();
      await super.init();
    });
  }

  Future<List<String>> get content => file.openRead().transform(utf8.decoder).transform(const LineSplitter()).toList();
  Stream<String> get stream async* {
    print("aaa");
    yield* file.openRead().transform(utf8.decoder).transform(const LineSplitter()).map((line) {
      print("file line: $line");
      return line;
    });
  }
}
