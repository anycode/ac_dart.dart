import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as lgg;

/// Debugging logger which logs events to console and multiple files (rotated)
class AcLogger extends Logger {
  /// All attached [Logger]s in the system.
  static final _loggers = <String, AcLogger>{};

  /// Name of the logger
  final String name;

  /// Minimal level for logging
  final Level? level;
  lgg.Logger? _loggingLogger;

  static singleton<T extends AcLogger>(String name, T Function() logger) => _loggers.putIfAbsent(name, logger);

  factory AcLogger({required String name, Level? level, LogOutput? output, LogFilter? filter, LogPrinter? printer}) =>
      singleton(name, () => AcLogger.instantiate(name: name, level: level, output: output, filter: filter, printer: printer));

  AcLogger.instantiate({
    required this.name,
    this.level,
    super.output,
    super.filter,
    super.printer,
  }) : super(level: level);

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
    _loggingLogger = logger;
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
