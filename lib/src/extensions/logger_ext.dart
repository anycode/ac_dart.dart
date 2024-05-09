import 'package:logger/logger.dart';

/// Methods for easier transition from package logging to AcLogger
extension LoggerExt on Logger {
  @Deprecated('Use t(message, error: error, stackTrace: stackTrace) instead')
  void finest(message, [Object? error, StackTrace? stackTrace]) => t(message, error: error, stackTrace: stackTrace);
  @Deprecated('Use t(message, error: error, stackTrace: stackTrace) instead')
  void trace(message, [Object? error, StackTrace? stackTrace]) => t(message, error: error, stackTrace: stackTrace);

  @Deprecated('Use t(message, error: error, stackTrace: stackTrace) instead')
  void finer(message, [Object? error, StackTrace? stackTrace]) => t(message, error: error, stackTrace: stackTrace);
  @Deprecated('Use d(message, error: error, stackTrace: stackTrace) instead')
  void debug(message, [Object? error, StackTrace? stackTrace]) => d(message, error: error, stackTrace: stackTrace);

  @Deprecated('Use i(message, error: error, stackTrace: stackTrace) instead')
  void info(message, [Object? error, StackTrace? stackTrace]) => i(message, error: error, stackTrace: stackTrace);

  @Deprecated('Use w(message, error: error, stackTrace: stackTrace) instead')
  void warning(message, [Object? error, StackTrace? stackTrace]) => w(message, error: error, stackTrace: stackTrace);

  @Deprecated('Use e(message, error: error, stackTrace: stackTrace) instead')
  void error(message, [Object? error, StackTrace? stackTrace]) => e(message, error: error, stackTrace: stackTrace);

  @Deprecated('Use f(message, error: error, stackTrace: stackTrace) instead')
  void fatal(message, [Object? error, StackTrace? stackTrace]) => f(message, error: error, stackTrace: stackTrace);
  @Deprecated('Use f(message, error: error, stackTrace: stackTrace) instead')
  void severe(message, [Object? error, StackTrace? stackTrace]) => f(message, error: error, stackTrace: stackTrace);
  @Deprecated('Use f(message, error: error, stackTrace: stackTrace) instead')
  void exception(message, [Object? error, StackTrace? stackTrace]) => f(message, error: error, stackTrace: stackTrace);
}
