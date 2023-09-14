import 'dart:collection';
import 'dart:developer' as dev;

import 'package:cancellation_token_http/http.dart' as http;
import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_log/http_extensions_log.dart';
import 'package:logging/logging.dart';

class PerformanceExtension extends Extension<LogOptions> {
  final Logger? logger;

  PerformanceExtension({LogOptions defaultOptions = const LogOptions(), this.logger}) : super(defaultOptions: defaultOptions);

  void log(String message, LogOptions options) {
    if (logger != null) {
      logger!.log(options.level, message);
    } else {
      dev.log(message, level: Level.FINER.value);
    }
  }

  int _id = 0;
  HashMap<int, int> requestTimestamps = HashMap();

  Future<String> _formatPerformance(int id, http.StreamedResponse response, LogOptions options) async {
    final requestLog = StringBuffer();

    var requestTimestamp = requestTimestamps[id];
    var responseTimestamp = DateTime.now().millisecondsSinceEpoch;

    requestLog.writeln('Performance report for REQ($id) [ ${response.request!.method} | ${response.request!.url}]');
    if (requestTimestamp == null) {
      requestLog.writeln('  * Request data lost');
    } else {
      requestLog.writeln('  * duration: ${responseTimestamp - requestTimestamp} ms');
    }

    requestTimestamps.remove(id);

    return requestLog.toString();
  }

  String _formatError(int id, http.BaseRequest request, dynamic error, StackTrace stackTrace, LogOptions options) {
    final errorLog = StringBuffer();

    var requestTimestamp = requestTimestamps[id];
    var responseTimestamp = DateTime.now().millisecondsSinceEpoch;

    errorLog.writeln('Performance report for failed REQ($id) [ ${request.method} | ${request.url} ]');
    if (requestTimestamp == null) {
      errorLog.writeln('  * Request data lost');
    } else {
      errorLog.writeln('  * duration: ${responseTimestamp - requestTimestamp} ms');
    }

    requestTimestamps.remove(id);

    return errorLog.toString();
  }

  @override
  Future<http.StreamedResponse> sendWithOptions(http.BaseRequest request, LogOptions options, { http.CancellationToken? cancellationToken}) async {
    if (!options.isEnabled) {
      return await super.sendWithOptions(request, options, cancellationToken: cancellationToken);
    }

    final id = _id++;

    if (options.logRequestContent) {
      request = BufferedRequest(request);
    }

    requestTimestamps[id] = DateTime.now().millisecondsSinceEpoch;

    try {
      var response = await super.sendWithOptions(request, options);

      if (options.logResponseContent) {
        response = BufferedStreamResponse(response);
      }

      final responseLog = await _formatPerformance(id, response, options);
      log(responseLog, options);

      return response;
    } catch (error, stacktrace) {
      final errorLog = _formatError(id, request, error, stacktrace, options);
      log(errorLog, options);
      rethrow;
    }
  }
}
