import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../storage/secure_storage_service.dart';

final Provider<SecureStorageService> secureStorageProvider =
    Provider<SecureStorageService>((Ref ref) => SecureStorageService());

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>(
  (Ref ref) => ApiClient(secureStorage: ref.watch(secureStorageProvider)),
);

/// Must be overridden in `main()` with the resolved [SharedPreferences]
/// instance before the app runs — see `bootstrap` in main.dart. Throwing
/// here makes a missing override fail loudly instead of silently.
final Provider<SharedPreferences> sharedPreferencesProvider =
    Provider<SharedPreferences>(
  (Ref ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden before runApp().',
  ),
);
