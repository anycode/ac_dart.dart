import 'package:http_extensions_log/http_extensions_log.dart';

class NoBinaryLogExtension extends LogExtension {
  NoBinaryLogExtension({LogOptions defaultOptions = const LogOptions(), logger})
      : super(
          defaultOptions: defaultOptions,
          logger: logger,
        );

  @override
  void log(String message, LogOptions options) {
    if (message.contains('�')) {
      message = '${message.substring(0, message.indexOf('�'))}[binary]';
    }

    super.log(message, options);
  }
}
