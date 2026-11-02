/// Standard Golden API Envelope & Exceptions
class ApiResponse<T> {
  final bool success;
  final String message;
  final String timestamp;
  final T? data;
  final String? errorCode;
  final List<dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    String? timestamp,
    this.data,
    this.errorCode,
    this.errors,
  }) : timestamp = timestamp ?? DateTime.now().toIso8601String();

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic rawData)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      errorCode: json['errorCode'] as String?,
      errors: json['errors'] as List<dynamic>?,
    );
  }

  @override
  String toString() => 'ApiResponse(success: $success, message: $message, data: $data)';
}

/// Custom API Exception with code and response envelope
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String? errorCode;
  final dynamic rawData;

  ApiException({
    required this.statusCode,
    required this.message,
    this.errorCode,
    this.rawData,
  });

  @override
  String toString() => 'ApiException [$statusCode]: $message (code: $errorCode)';
}

