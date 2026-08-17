import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

final Provider<FavoritesLocalDataSource> favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>(
  (Ref ref) =>
      FavoritesLocalDataSourceImpl(ref.watch(sharedPreferencesProvider)),
);

final Provider<FavoritesRepository> favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (Ref ref) =>
      FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider)),
);

final Provider<ToggleFavoriteUseCase> toggleFavoriteUseCaseProvider =
    Provider<ToggleFavoriteUseCase>(
  (Ref ref) => ToggleFavoriteUseCase(ref.watch(favoritesRepositoryProvider)),
);

class FavoritesController extends StateNotifier<Set<int>> {
  FavoritesController({
    required FavoritesRepository repository,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  })  : _repository = repository,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
        super(const <int>{}) {
    _load();
  }

  final FavoritesRepository _repository;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  Future<void> _load() async {
    state = await _repository.loadFavorites();
  }

  bool isFavorite(int productId) => state.contains(productId);

  Future<void> toggle(int productId) async {
    final Set<int> previous = state;
    // Optimistic update keeps the UI snappy; we still persist right away.
    state = previous.contains(productId)
        ? (Set<int>.from(previous)..remove(productId))
        : (Set<int>.from(previous)..add(productId));
    await _toggleFavoriteUseCase(productId, previous);
  }
}

final StateNotifierProvider<FavoritesController, Set<int>>
    favoritesControllerProvider =
    StateNotifierProvider<FavoritesController, Set<int>>((Ref ref) {
  return FavoritesController(
    repository: ref.watch(favoritesRepositoryProvider),
    toggleFavoriteUseCase: ref.watch(toggleFavoriteUseCaseProvider),
  );
});
