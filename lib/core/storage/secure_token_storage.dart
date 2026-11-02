import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

/// Enterprise Secure Storage for Golden authentication tokens & session state.
/// Backed by Android Keystore (EncryptedSharedPreferences) and iOS Keychain.
class SecureTokenStorage {
  static final SecureTokenStorage instance = SecureTokenStorage._internal();
  factory SecureTokenStorage() => instance;
  SecureTokenStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _keyToken = 'golden_auth_token';
  static const String _keyUser = 'golden_user_profile';

  /// Save authentication bearer token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Retrieve stored authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (_) {
      return null;
    }
  }

  /// Remove stored token
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyToken);
    } catch (_) {}
  }

  /// Persist user profile to secure storage for instant cold-start recovery
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonStr = jsonEncode(user.toJson());
      await _storage.write(key: _keyUser, value: jsonStr);
    } catch (_) {}
  }

  /// Read cached user profile from secure storage
  Future<UserModel?> getUser() async {
    try {
      final jsonStr = await _storage.read(key: _keyUser);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final Map<String, dynamic> map = jsonDecode(jsonStr);
        return UserModel.fromJson(map);
      }
    } catch (_) {}
    return null;
  }

  /// Complete wipe of all session credentials from secure hardware storage
  Future<void> clearAuth() async {
    try {
      await _storage.delete(key: _keyToken);
      await _storage.delete(key: _keyUser);
    } catch (_) {
      try {
        await _storage.deleteAll();
      } catch (_) {}
    }
  }

  /// Inspects a JWT token to check if it has expired.
  /// If the token is empty, malformed, or past its expiration date, returns true.
  bool isTokenExpired(String? token) {
    if (token == null || token.trim().isEmpty) return true;

    final parts = token.split('.');
    if (parts.length != 3) {
      // If server issues an opaque custom token (not 3-part JWT),
      // we do not assume expired locally; the server will validate it.
      return false;
    }

    try {
      var payload = parts[1];
      // Normalize base64 padding
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decodedBytes = base64Url.decode(payload);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> data = jsonDecode(decodedString);

      if (data.containsKey('exp')) {
        final exp = data['exp'];
        if (exp is num) {
          final expiryDate = DateTime.fromMillisecondsSinceEpoch(
            (exp * 1000).round(),
            isUtc: true,
          );
          // Expired if current UTC time is past (or within 30s of) expiration
          return DateTime.now().toUtc().isAfter(
                expiryDate.subtract(const Duration(seconds: 30)),
              );
        }
      }
      return false;
    } catch (_) {
      // If decoding fails, treat token as invalid/expired
      return true;
    }
  }

  /// Checks whether a valid, non-expired authentication token is currently stored
  Future<bool> hasValidSession() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    return !isTokenExpired(token);
  }
}

