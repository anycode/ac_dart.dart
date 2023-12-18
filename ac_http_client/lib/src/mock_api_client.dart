import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

class MockApiClient {
  Future<Response> get(String path,
      {String? host, String? url, Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    final resp = await _mock(path);
    return resp;
  }

  Future<Response> post(String path,
      {String? host, String? url, Map<String, String>? headers, body, Encoding? encoding, Map<String, String>? queryParameters}) {
    //body = json.encode(body);
    return _mock(path);
  }

  Future<Response> put(String path,
      {String? host, String? url, Map<String, String>? headers, body, Encoding? encoding, Map<String, String>? queryParameters}) {
    //body = json.encode(body);
    return _mock(path);
  }

  Future<Response> patch(String path,
      {String? host, String? url, Map<String, String>? headers, body, Encoding? encoding, Map<String, String>? queryParameters}) {
    //body = json.encode(body);
    return _mock(path);
  }

  Future<Response> delete(String path,
      {String? host, String? url, Map<String, String>? headers, dynamic body, Map<String, String>? queryParameters}) async {
    //body = json.encode(body);
    return _mock(path);
  }

  Future<Response> _mock(String path) async {
    try {
      final mock = await rootBundle.loadString('assets/mock/responses/${path.replaceAll('/', '-')}.json');
      dynamic json;
      try {
        json = jsonDecode(mock);
      } catch (e) {
        return Response('MOCK INVALID JSON', 500, reasonPhrase: 'Mock $path is not valid json: $mock');
      }
      if (json is Map && json.containsKey('body') && json.containsKey('code')) {
        return Response(jsonEncode(json['body']), json['code'],
            headers: json['headers'] ?? <String, String>{'Content-Type': 'application/json'});
      } else {
        throw Exception('Invalid MOCK JSON on path $path');
      }
    } catch (e) {
      return Response('MOCK FILE NOT FOUND', 404, reasonPhrase: 'Mock $path not found');
    }
  }

}
