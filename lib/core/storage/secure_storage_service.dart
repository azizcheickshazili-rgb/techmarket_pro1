import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Thin wrapper around [FlutterSecureStorage] so the rest of the app
/// never talks to the platform keychain/keystore directly. This keeps
/// the dependency mockable in tests and swappable later on.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(
      key: AppConstants.refreshTokenKey,
      value: refreshToken,
    );
  }

  Future<String?> readAccessToken() =>
      _storage.read(key: AppConstants.accessTokenKey);

  Future<String?> readRefreshToken() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  Future<void> clear() async {
    await _storage.delete(key: AppConstants.accessTokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }

  Future<bool> hasValidSession() async {
    final String? token = await readAccessToken();
    return token != null && token.isNotEmpty;
  }
}
