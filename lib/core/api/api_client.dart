import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'api_config.dart';
import 'api_response.dart';

void _debugLog(String message) {
  developer.log(message, name: 'GoldenAPI');
  // ignore: avoid_print
  print(message);
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _authToken;
  String? get authToken => _authToken;

  
  void Function()? onUnauthorized;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  /// Execute HTTP GET
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>('GET', endpoint, queryParams: queryParams, fromJson: fromJson);
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? idempotencyKey,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      'POST',
      endpoint,
      body: body,
      queryParams: queryParams,
      idempotencyKey: idempotencyKey,
      fromJson: fromJson,
    );
  }

 
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      'PUT',
      endpoint,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

 
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    return _sendRequest<T>(
      'PATCH',
      endpoint,
      body: body,
      queryParams: queryParams,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> _sendRequest<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? idempotencyKey,
    T Function(dynamic)? fromJson,
  }) async {
    final client = HttpClient();
    client.connectionTimeout = ApiConfig.timeout;
    final stopwatch = Stopwatch()..start();
    final uri = _buildUri(endpoint, queryParams);

    if (ApiConfig.enableLogging) {
      _debugLog('┌── 🌐 [API REQ] $method $uri');
      if (_authToken != null && _authToken!.isNotEmpty) {
        final maskedToken = _authToken!.length > 12 ? '${_authToken!.substring(0, 8)}...' : '***';
        _debugLog('│ 🔑 Bearer: $maskedToken');
      }
      if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
        _debugLog('│ 🆔 Idempotency: $idempotencyKey');
      }
      if (body != null) {
        _debugLog('│ 📤 Payload: ${jsonEncode(body)}');
      }
    }

    try {
      final request = await _openRequest(client, method, uri);

    
      ApiConfig.defaultHeaders.forEach((key, value) {
        request.headers.set(key, value);
      });

      if (_authToken != null && _authToken!.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_authToken');
      }

      if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
        request.headers.set('X-Idempotency-Key', idempotencyKey);
      }

      if (body != null) {
        final jsonString = jsonEncode(body);
        request.write(jsonString);
      }

      final response = await request.close().timeout(ApiConfig.timeout);
      final responseBody = await response.transform(utf8.decoder).join();
      final statusCode = response.statusCode;
      final elapsed = stopwatch.elapsedMilliseconds;

      if (ApiConfig.enableLogging) {
        final statusBadge = (statusCode >= 200 && statusCode < 300) ? '✅' : '⚠️';
        _debugLog('├── $statusBadge [API RES $statusCode] (${elapsed}ms) $uri');
        final preview = responseBody.length > 500 ? '${responseBody.substring(0, 500)}...[truncated]' : responseBody;
        _debugLog('└── 📦 Data: $preview');
      }

      final parsedJson = jsonDecode(responseBody) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        return ApiResponse<T>.fromJson(parsedJson, fromJson);
      } else {
        if (statusCode == 401) {
          if (ApiConfig.enableLogging) {
            _debugLog('⚠️ [API 401 UNAUTHORIZED] Token expired or invalid -> triggering auth handler');
          }
          onUnauthorized?.call();
        }
        return ApiResponse<T>(
          success: false,
          message: parsedJson['message'] as String? ?? 'Request failed with status $statusCode',
          errorCode: parsedJson['errorCode'] as String?,
          timestamp: parsedJson['timestamp'] as String?,
        );
      }
    } on SocketException catch (e) {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (ApiConfig.enableLogging) {
        _debugLog('└── ❌ [API SOCKET ERROR] (${elapsed}ms) $uri -> ${e.message}');
      }
      return ApiResponse<T>(
        success: false,
        message: 'Cannot connect to backend at ${ApiConfig.baseUrl}. (${e.message})',
      );
    } on TimeoutException {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (ApiConfig.enableLogging) {
        _debugLog('└── ⏳ [API TIMEOUT] (${elapsed}ms) $uri');
      }
      return ApiResponse<T>(
        success: false,
        message: 'Connection timed out while reaching ${ApiConfig.baseUrl}.',
      );
    } on FormatException catch (e) {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (ApiConfig.enableLogging) {
        _debugLog('└── ⚠️ [API JSON FORMAT ERROR] (${elapsed}ms) $uri -> ${e.message}');
      }
      return ApiResponse<T>(
        success: false,
        message: 'Invalid response format from server: ${e.message}',
      );
    } catch (e) {
      final elapsed = stopwatch.elapsedMilliseconds;
      if (ApiConfig.enableLogging) {
        _debugLog('└── ❌ [API UNEXPECTED ERROR] (${elapsed}ms) $uri -> $e');
      }
      return ApiResponse<T>(
        success: false,
        message: 'Network request error: $e',
      );
    } finally {
      client.close();
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    var url = ApiConfig.url(endpoint);
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      url = '$url?$queryString';
    }
    return Uri.parse(url);
  }

  Future<HttpClientRequest> _openRequest(HttpClient client, String method, Uri uri) {
    switch (method.toUpperCase()) {
      case 'POST':
        return client.postUrl(uri);
      case 'PUT':
        return client.putUrl(uri);
      case 'DELETE':
        return client.deleteUrl(uri);
      case 'GET':
      default:
        return client.getUrl(uri);
    }
  }
}
