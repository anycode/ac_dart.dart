import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ac_dart/ac_dart.dart';
import 'package:cancellation_token_http/http.dart';
import 'package:http_extensions/http_extensions.dart';
import 'package:http_extensions_base_url/http_extensions_base_url.dart';
import 'package:http_extensions_headers/http_extensions_headers.dart';
import 'package:http_extensions_log/http_extensions_log.dart';
import 'package:http_extensions_retry/http_extensions_retry.dart';
import 'package:logging/logging.dart';

import 'logging/nobinary_log_extension.dart';
import 'logging/performance_extension.dart';
import 'model/api_error.dart';
import 'model/api_exception.dart';
import 'model/media.dart';
import 'model/multipart.dart';

typedef UriBuilder = Uri Function({String? url, String? host, int? port, String? path, Map<String, dynamic>? queryParameters});
typedef ErrorHandler = Response Function(Response error);

class ApiClient {
  final BaseClient _client;
  final Uri? baseUri;
  final UriBuilder? uriBuilder;
  final ErrorHandler? errorHandler;
  final Duration? defaultTimeout;

  final cancellationTokens = <String, CancellationToken>{};

  ApiClient({
    this.baseUri,
    required BaseClient inner,
    LogOptions? logOptions,
    HeadersOptions? headersOptions,
    RetryOptions? retryOptions,
    Logger? logger,
    Logger? baseUrlLogger,
    Logger? retryLogger,
    Logger? headerLogger,
    Logger? performanceLogger,
    Logger? httpLogger,
    this.uriBuilder,
    this.errorHandler,
    this.defaultTimeout = const Duration(minutes: 5),
  }) : _client = ExtendedClient(
          inner: inner,
          extensions: [
            if (baseUri != null)
              BaseUrlExtension(
                logger: baseUrlLogger ?? logger ?? Logger('BaseUrl'),
                defaultOptions: BaseUrlOptions(
                  url: baseUri,
                ),
              ),
            RetryExtension(
              logger: retryLogger ?? logger ?? Logger('Retry'),
              defaultOptions: retryOptions ??
                  RetryOptions(
                    retries: 3, // Number of retries before a failure
                    retryInterval: const Duration(seconds: 5), // Interval between each retry
                    retryEvaluator: (error, response) => error != null,
                  ),
            ),
            HeadersExtension(
              logger: headerLogger ?? logger ?? Logger('Headers'),
              defaultOptions: headersOptions ??
                  HeadersOptions(
                    headersBuilder: (request) => {
                      'Content-Type': ContentType.json.mimeType,
                    },
                  ),
            ),
            PerformanceExtension(
              logger: performanceLogger ?? logger ?? Logger('Performance'),
              defaultOptions: logOptions ?? const LogOptions(),
            ),
            // Keep LogExtension last as it wraps the request with BufferedRequest and
            // headersBuilder() of HeadersExtension won't modify original request and no
            // extra headers are sent
            NoBinaryLogExtension(
              logger: httpLogger ?? logger ?? Logger('Http'),
              defaultOptions: logOptions ?? const LogOptions(),
            ),
          ],
        );

  Future<Response> get(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'GET',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> post(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    body,
    Encoding? encoding,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'POST',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      body: body,
      encoding: encoding,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> postMultipart(
    path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    List<MultipartField>? fields,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendMultipart(
      'POST',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      fields: fields,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> put(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    body,
    Encoding? encoding,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'PUT',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      body: body,
      encoding: encoding,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> putMultipart(
    path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    List<MultipartField>? fields,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendMultipart(
      'PUT',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      fields: fields,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> patch(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    body,
    Encoding? encoding,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'PATCH',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      body: body,
      encoding: encoding,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> patchMultipart(
    path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    List<MultipartField>? fields,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) async {
    return _sendMultipart(
      'PATCH',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      fields: fields,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  // DELETE by default doesn't support body, so pass it manually via http.Request
  Future<Response> delete(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'DELETE',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      body: body,
      encoding: encoding,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  Future<Response> exec(
    String path, {
    String? host,
    String? url,
    Map<String, String>? headers,
    dynamic body,
    Encoding? encoding,
    Map<String, String>? queryParameters,
    Duration? timeout,
    bool cancelRunning = false,
  }) {
    return _sendUnstreamed(
      'EXEC',
      _uriBuilder(url: url, host: host, path: path, queryParameters: queryParameters),
      body: body,
      encoding: encoding,
      headers: headers,
      timeout: timeout,
      cancelRunning: cancelRunning,
    );
  }

  void close() {
    _client.close();
  }

  Future<StreamedResponse> send(BaseRequest request, {CancellationToken? cancellationToken}) {
    return _client.send(request, cancellationToken: cancellationToken);
  }

  // cancelable version of BaseClient._sendUnstreamed(...)
  Future<Response> _sendUnstreamed(
    String method,
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
    bool cancelRunning = false,
  }) async {
    var request = Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    final ctName = '$method ${url.path}';
    var ct = cancellationTokens[ctName];
    if (cancelRunning && ct != null && !ct.isCancelled) {
      log('canceling request $ctName with token ${ct.hashCode}', level: Level.FINER.value);
      ct.cancel();
    }
    try {
      cancellationTokens[ctName] = CancellationToken();
      timeout ??= defaultTimeout;
      final req = send(request, cancellationToken: cancellationTokens[ctName]);
      final resp = timeout != null ? await req.timeout(timeout) : await req;
      cancellationTokens.remove(ctName);
      return _throwIfError(await Response.fromStream(resp));
    } on CancelledException {
      log('request $ctName canceled', level: Level.FINER.value);
      rethrow;
    }
  }

  Future<Response> _sendMultipart(
    String method,
    Uri url, {
    List<MultipartField>? fields,
    Map<String, String>? headers,
    Duration? timeout,
    bool cancelRunning = false,
  }) async {
    var request = MultipartRequest(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (fields != null) {
      for (final field in fields) {
        if (field.type == MultipartFieldType.media) {
          log('file ${field.name}', level: Level.FINER.value);
          final media = field.value as Media;
          request.files.add(await MultipartFile.fromPath('file', media.path));
        } else {
          request.fields[field.name] = field.value;
        }
      }
    }

    final ctName = '$method ${url.path}';
    var ct = cancellationTokens[ctName];
    if (cancelRunning && ct != null && !ct.isCancelled) {
      log('canceling request $ctName with token ${ct.hashCode}', level: Level.FINER.value);
      ct.cancel();
    }
    try {
      cancellationTokens[ctName] = CancellationToken();
      timeout ??= defaultTimeout;
      final req = send(request, cancellationToken: cancellationTokens[ctName]);
      final resp = timeout != null ? await req.timeout(timeout) : await req;
      cancellationTokens.remove(ctName);
      return _throwIfError(await Response.fromStream(resp));
    } on CancelledException {
      log('request $ctName canceled', level: Level.FINER.value);
      rethrow;
    }
  }

  UriBuilder get _uriBuilder =>
      uriBuilder ??
      ({String? url, String? host, int? port, String? path, Map<String, dynamic>? queryParameters}) {
        final Uri uri;
        if (url != null) {
          if (url.startsWith('http://') || url.startsWith('https://')) {
            // full URL
            uri = Uri.parse(url);
          } else if (url.startsWith('/')) {
            // absolute path starting with '/'
            uri = baseUri!.replace(path: url, queryParameters: queryParameters);
          } else {
            // relative path, append to base
            final path = '${baseUri!.path}/$url';
            uri = baseUri!.replace(path: path, queryParameters: queryParameters);
          }
        } else {
          if (path?.startsWith('/') == false) {
            path = '${baseUri!.path}/$path';
          }
          uri = baseUri!.replace(host: host, path: path, port: port);
        }
        return uri.replace(queryParameters: queryParameters);
      };

  Response _throwIfError(Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return response;
    }
    if(errorHandler != null) {
      return errorHandler!.call(response);
    }
    ApiError error;
    final contentType = ContentType.parse(response.headers['content-type'] ?? '');
    if (contentType.mimeType == ContentType.json.mimeType) {
      final dynamic err = json.decodeBytes(response.bodyBytes);
      if (err is Map) {
        error = ApiError.fromJson(err as Map<String, dynamic>);
      } else {
        error = ApiError(status: response.statusCode, error: err.toString());
      }
    } else if ([ContentType.html.mimeType, ContentType.text.mimeType].contains(contentType.mimeType)) {
      error = ApiError(status: response.statusCode, error: response.bodyBytes.toString());
    } else {
      error = ApiError(status: response.statusCode, error: 'Unknown error');
    }
    throw ApiException(response.statusCode, response.reasonPhrase, error);
  }
}

void throwNotImplementedYet() {
  throw ApiException(500, 'Funkce nebyla implementována', ApiError(status: 500, error: 'Funkce nebyla implementována'));
}
