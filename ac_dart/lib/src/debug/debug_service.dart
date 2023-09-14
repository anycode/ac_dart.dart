import 'dart:io';

import 'package:logger/logger.dart';
import 'package:media_storage/media_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'debug_logger.dart';

class DebugService {
  static const defaultPath = '{pkg}/files/logs';

  /// Logger created in the default constructor used for logging generic app events
  late DebugLogger appLogger;

  /// Logger created in the default constructor used for logging API events
  late DebugLogger apiLogger;

  /// Logger created in the default constructor used for logging performance
  late DebugLogger performanceLogger;

  /// Logger created in the default constructor used for logging errors
  late DebugLogger errorLogger;

  /// List of names of loggers to be created in [named] constructor
  final List<String> names;

  /// Name of root media directory used for storing logs. Should be one of
  /// [MediaStorage] directories, default is [MediaStorage.DIRECTORY_DOWNLOADS]
  final String root;

  /// Path under the root directory used for storing logs. Should contain {pkg}
  /// place holder which is replaces with the package name. Default is '{pkg}/files/logs'
  final String path;

  /// Minimum log level
  Level? level;

  /// Map of created loggers, the keys are loggers names passed in the [named]
  /// constructor
  final loggers = <String, DebugLogger>{};

  /// Constructor used for creating named loggers
  DebugService.named({
    String? root,
    this.level,
    this.path = defaultPath,
    required this.names,
  }) : root = root ?? MediaStorage.DIRECTORY_DOWNLOADS {
    _init();
  }

  /// Constructor creating default loggers
  DebugService({
    String? root,
    this.level,
    this.path = defaultPath,
  })  : root = root ?? MediaStorage.DIRECTORY_DOWNLOADS,
        names = ['app', 'api', 'performance', 'error'] {
    _init().then((_) {
      appLogger = loggers['app']!;
      apiLogger = loggers['api']!;
      performanceLogger = loggers['performance']!;
      errorLogger = loggers['error']!;
    });
  }

  Future<bool> _init() async {
    String dir;
    if (path.contains('{pkg}')) {
      var pkg = await PackageInfo.fromPlatform();
      dir = path.replaceAll('{pkg}', pkg.packageName);
    } else {
      dir = path;
    }

    final rootDir = await MediaStorage.getExternalStoragePublicDirectory(root);
    if (await MediaStorage.getRequestStoragePermission()) {
      try {
        await MediaStorage.CreateDir(rootDir, dir);
      } catch (e) {
        print('$e');
        return false;
      }
      for(final name in names) {
        final file = File('$rootDir/$dir/$name.log');
        loggers[name] = DebugLogger(
          name: name,
          level: level,
          output: MultiFileOutput(file: file),
        );
      }
      return true;
    } else {
      return false;
    }
  }
}
