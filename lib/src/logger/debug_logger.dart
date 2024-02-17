import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'ac_logger.dart';

/// Debugging logger which logs events to console and multiple files (rotated)
class DebugLogger extends AcLogger {
  /// [MultiFileOutput] output
  final MultiFileOutput? _output;

  MultiFileOutput? get output => _output;

  /// Creates/returns a single logger with given name. Optionally, a level, a multi file output, a filter and a printer can be provided.
  /// If you need multiple instances, use [DebugLogger.instantiate()] constructor.
  factory DebugLogger({
    required String name,
    Level? level,
    MultiFileOutput? output,
    LogFilter? filter,
    LogPrinter? printer,
  }) =>
      AcLogger.singleton(name, () => DebugLogger.instantiate(name: name, level: level, output: output, filter: filter, printer: printer));

  /// Creates new instance of [DebugLogger]. Each call creates new instance, even if name is the same.
  /// If you need single instance, use [DebugLogger()] factory constructor.
  DebugLogger.instantiate({
    required super.name,
    super.level,
    MultiFileOutput? output,
    LogFilter? filter,
    LogPrinter? printer,
  })  : _output = output,
        super.instantiate(
          output: MultiOutput([output, ConsoleOutput()]),
          filter: filter ?? DevelopmentFilter(),
          printer: printer ?? DebugPrinter(),
        );
}

/// Default [LogPrinter] for [DebugLogger]
class DebugPrinter extends LogPrinter {
  static const uuid = Uuid();

  @override
  List<String> log(LogEvent event) {
    final recId = uuid.v1().substring(0, 8);
    return [
      ...stringifyMessage(event.message).split('\n').map((line) => '$recId | ${event.time} | ${event.level.name} | $line'),
      if (event.error != null) '$recId | ${event.time} | ${event.level.name} | error:\n',
      if (event.error != null)
        ...event.error.toString().split('\n').map((line) => '$recId | ${event.time} | ${event.level.name} |   $line\n'),
      if (event.stackTrace != null) '$recId | ${event.time} | ${event.level.name} | stack trace: \n',
      if (event.stackTrace != null)
        ...event.stackTrace.toString().split('\n').map((line) => '$recId | ${event.time} | ${event.level.name} |   $line\n'),
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

  MultiFileOutput({
    required this.file,
    super.overrideExisting = false,
    super.encoding = utf8,
    this.maxFiles = defaultMaxFiles,
    this.maxSize = defaultMaxSize,
  }) : super(file: file);

  @override
  Future<void> init() async {
    final files = <File>[];
    final base = basenameWithoutExtension(file.path);
    final ext = extension(file.path);
    final dir = dirname(file.path);
    if (maxFiles > 0) {
      for (int i = 0; i < maxFiles; i++) {
        final filename = '$dir/$base.$i.$ext';
        files.add(File(filename));
      }
    }
    return super.init();
  }

  List<File> get files => _files;

  List<XFile> get xFiles => _files.map((f) => XFile(f.path)).toList();

  void clearLog() {
    for (final file in _files) {
      if (file.existsSync() == true) {
        file.deleteSync();
      }
    }
    init();
  }

  @override
  void output(OutputEvent event) {
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
      super.destroy();
      file.deleteSync();
    }
    file.createSync();
    super.init();
  }

  Future<List<String>> get content async => await file.openRead().transform(utf8.decoder).transform(const LineSplitter()).toList();
}
