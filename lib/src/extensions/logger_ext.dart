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
