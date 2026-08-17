abstract final class AppConstants {
  static const String appName = 'TechMarket';

  // Secure storage keys
  static const String accessTokenKey = 'tm_access_token';
  static const String refreshTokenKey = 'tm_refresh_token';

  // Shared preferences keys
  static const String favoritesKey = 'tm_favorites';
  static const String localeKey = 'tm_locale';
  static const String cachedUserKey = 'tm_cached_user';

  static const Duration splashMinDuration = Duration(milliseconds: 900);
}
