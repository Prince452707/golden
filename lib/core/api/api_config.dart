
class ApiConfig {
  /// Active Server API Base URL
  static const String baseUrl = 'http://129.121.133.31:5000/api/v1';
 //'https://unbent-smashing-negation.ngrok-free.dev/api/v1';
  /// Connection and Read Timeout
  static const Duration timeout = Duration(seconds: 15);

  /// Standard Headers applied to every request
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Client-Platform': 'Flutter-Golden-App',
    'X-Client-Version': '1.0.0',
    'ngrok-skip-browser-warning': 'true',
  };

  /// Enable / disable console debug logging for HTTP requests
  static bool enableLogging = true;

  /// Helper to build full endpoint URL
  static String url(String endpoint) {
    if (endpoint.startsWith('/')) {
      return '$baseUrl$endpoint';
    }
    return '$baseUrl/$endpoint';
  }
}
