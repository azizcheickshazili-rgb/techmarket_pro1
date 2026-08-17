import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:techmarket/features/favorites/data/repositories/favorites_repository_impl.dart';

class _MockFavoritesLocalDataSource extends Mock implements FavoritesLocalDataSource {}

void main() {
  late _MockFavoritesLocalDataSource localDataSource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    localDataSource = _MockFavoritesLocalDataSource();
    repository = FavoritesRepositoryImpl(localDataSource);
    when(() => localDataSource.saveFavoriteIds(any())).thenAnswer((_) async {});
  });

  test('toggleFavorite adds the id when it is not already present', () async {
    await repository.toggleFavorite(42, <int>{1, 2});

    verify(() => localDataSource.saveFavoriteIds(<int>{1, 2, 42})).called(1);
  });

  test('toggleFavorite removes the id when it is already present', () async {
    await repository.toggleFavorite(2, <int>{1, 2});

    verify(() => localDataSource.saveFavoriteIds(<int>{1})).called(1);
  });

  test('loadFavorites delegates to the local data source', () async {
    when(() => localDataSource.getFavoriteIds()).thenAnswer((_) async => <int>{7});

    final Set<int> result = await repository.loadFavorites();

    expect(result, <int>{7});
  });
}
