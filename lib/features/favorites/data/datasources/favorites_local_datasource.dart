import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

/// Persists favorite product IDs as a simple string set in
/// SharedPreferences. Favorites are a device-local concern in this app
/// (DummyJSON has no per-user favorites endpoint), so no network call
/// is involved — keeping toggles instant and offline-friendly.
abstract interface class FavoritesLocalDataSource {
  Future<Set<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  const FavoritesLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<Set<int>> getFavoriteIds() async {
    final List<String> raw =
        _prefs.getStringList(AppConstants.favoritesKey) ?? <String>[];
    return raw.map(int.parse).toSet();
  }

  @override
  Future<void> saveFavoriteIds(Set<int> ids) async {
    await _prefs.setStringList(
      AppConstants.favoritesKey,
      ids.map((int e) => e.toString()).toList(),
    );
  }
}
