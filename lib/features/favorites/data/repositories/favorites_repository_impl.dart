import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._localDataSource);

  final FavoritesLocalDataSource _localDataSource;

  @override
  Future<Set<int>> loadFavorites() => _localDataSource.getFavoriteIds();

  @override
  Future<void> toggleFavorite(int productId, Set<int> current) async {
    final Set<int> updated = Set<int>.from(current);
    if (!updated.remove(productId)) {
      updated.add(productId);
    }
    await _localDataSource.saveFavoriteIds(updated);
  }
}
