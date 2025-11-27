/// data/services/api_client.dart
/// Thin wrapper around HTTP client to centralize networking concerns.

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_endpoints.dart';

/// Provides REST helpers with consistent headers and error handling.
class ApiClient {
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('${AppEndpoints.baseUrl}$path').replace(queryParameters: query);
    final response = await _httpClient.get(uri, headers: _headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException('GET $path failed (${response.statusCode})');
  }

  Future<dynamic> post(String path, {Map<String, String>? query, Object? body}) async {
    final uri = Uri.parse('${AppEndpoints.baseUrl}$path').replace(queryParameters: query);
    final response = await _httpClient.post(
      uri,
      headers: _headers,
      body: body == null ? null : jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw ApiException('POST $path failed (${response.statusCode})');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}

/// Domain-specific error surfaced to repositories.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => 'ApiException: $message';
}

