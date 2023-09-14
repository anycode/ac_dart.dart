import 'dart:convert';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as lgg;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

/// Debugging logger which logs events to console and multiple files (rotated)
class DebugLogger extends Logger {
  /// Name of the logger
  final String name;
  /// Minimal level for logging
  final Level? level;
  /// [MultiFileOutput] output
  MultiFileOutput? output;
  lgg.Logger? _loggingLogger;

  DebugLogger({
    required this.name,
    this.output,
    this.level,
    LogFilter? filter,
    LogPrinter? printer,
  }) : super(
          output: MultiOutput([output, ConsoleOutput()]),
          filter: filter ?? DevelopmentFilter(),
          printer: printer ?? DebugPrinter(),
          level: level,
        );

  /// Returns Logger from https://pub.dev/packages/logging package. Starts listening for events on
  /// logging logger and logs the events to self.
  /// If needed for some reasons, e.g. for HTTP Extensions https://pub.dev/packages/http_extensions
  lgg.Logger get loggingLogger {
    if (_loggingLogger == null) {
      lgg.hierarchicalLoggingEnabled = true;
      _loggingLogger = lgg.Logger(name);
      _loggingLogger!.level = _invertLevel(level);
      // For some reason, all loggers leak into the listener, therefore we filter it once more by name
      _loggingLogger!.onRecord
          .where((event) => event.loggerName == _loggingLogger!.name)
          .listen((event) => log(_convertLevel(event.level), event.message, error: event.error, stackTrace: event.stackTrace));
    }
    return _loggingLogger!;
  }

  /// Sets Logger from https://pub.dev/packages/logging package. Starts listening for events on
  /// logging logger and logs the events to self.
  set loggingLogger(lgg.Logger logger) {
    lgg.hierarchicalLoggingEnabled = true;
    _loggingLogger = loggingLogger;
    _loggingLogger!.level = _invertLevel(level);
    // For some reason, all loggers leak into the listener, therefore we filter it once more nby name
    _loggingLogger!.onRecord
        .where((event) => event.loggerName == _loggingLogger!.name)
        .listen((event) => log(_convertLevel(event.level), event.message, error: event.error, stackTrace: event.stackTrace));
  }

  Level _convertLevel(lgg.Level? level) {
    return switch (level) {
      lgg.Level.ALL => Level.all,
      lgg.Level.OFF => Level.off,
      lgg.Level.FINEST => Level.trace,
      lgg.Level.FINER => Level.debug,
      lgg.Level.FINE => Level.debug,
      lgg.Level.CONFIG => Level.info,
      lgg.Level.INFO => Level.info,
      lgg.Level.WARNING => Level.warning,
      lgg.Level.SEVERE => Level.error,
      lgg.Level.SHOUT => Level.fatal,
      _ => Level.off,
    };
  }

  lgg.Level _invertLevel(Level? level) {
    return switch (level) {
      Level.all => lgg.Level.ALL,
      Level.off => lgg.Level.OFF,
      Level.trace => lgg.Level.FINEST,
      Level.debug => lgg.Level.FINE,
      Level.info => lgg.Level.INFO,
      Level.warning => lgg.Level.WARNING,
      Level.error => lgg.Level.SEVERE,
      Level.fatal => lgg.Level.SHOUT,
      _ => lgg.Level.OFF,
    };
  }
}

class DebugPrinter extends LogPrinter {
  static const uuid = Uuid();

  @override
  List<String> log(LogEvent event) {
    final recId = uuid.v1().substring(0, 8);
    return [
      ...stringifyMessage(event.message).split('\n').map((line) => '$recId | ${event.time} | ${event.level.name} | $line'),
      if (event.error != null) '$recId | ${event.time} | ${event.level.name} | error:\n',
      if (event.error != null) ...event.error.toString().split('\n').map((line) => '$recId | ${event.time} | ${event.level.name} |   $line\n'),
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
    for(final file in _files) {
      if(file.existsSync() == true) {
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
