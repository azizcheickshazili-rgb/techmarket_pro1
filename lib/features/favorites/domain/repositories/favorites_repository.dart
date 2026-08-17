abstract interface class FavoritesRepository {
  Future<Set<int>> loadFavorites();
  Future<void> toggleFavorite(int productId, Set<int> current);
}
