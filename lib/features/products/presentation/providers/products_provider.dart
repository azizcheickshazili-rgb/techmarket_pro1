import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/products_remote_datasource.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_product_by_id_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/search_products_usecase.dart';

final Provider<ProductsRemoteDataSource> productsRemoteDataSourceProvider =
    Provider<ProductsRemoteDataSource>(
  (Ref ref) => ProductsRemoteDataSourceImpl(ref.watch(apiClientProvider).dio),
);

final Provider<ProductsRepository> productsRepositoryProvider =
    Provider<ProductsRepository>(
  (Ref ref) =>
      ProductsRepositoryImpl(ref.watch(productsRemoteDataSourceProvider)),
);

final Provider<GetProductsUseCase> getProductsUseCaseProvider =
    Provider<GetProductsUseCase>(
  (Ref ref) => GetProductsUseCase(ref.watch(productsRepositoryProvider)),
);

final Provider<GetProductByIdUseCase> getProductByIdUseCaseProvider =
    Provider<GetProductByIdUseCase>(
  (Ref ref) => GetProductByIdUseCase(ref.watch(productsRepositoryProvider)),
);

final Provider<SearchProductsUseCase> searchProductsUseCaseProvider =
    Provider<SearchProductsUseCase>(
  (Ref ref) => SearchProductsUseCase(ref.watch(productsRepositoryProvider)),
);

/// Paginated product list state.
class ProductsListState {
  const ProductsListState({
    this.products = const <ProductEntity>[],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.errorMessage,
  });

  final List<ProductEntity> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? errorMessage;

  ProductsListState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? errorMessage,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage,
    );
  }
}

class ProductsListController extends StateNotifier<ProductsListState> {
  ProductsListController(this._getProducts) : super(const ProductsListState()) {
    loadFirstPage();
  }

  final GetProductsUseCase _getProducts;
  static const int _pageSize = 20;
  int _skip = 0;

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _skip = 0;
    final Result<List<ProductEntity>> result =
        await _getProducts(limit: _pageSize, skip: 0);
    state = result.when(
      ok: (List<ProductEntity> products) {
        _skip = products.length;
        return state.copyWith(
          products: products,
          isLoading: false,
          hasReachedEnd: products.length < _pageSize,
        );
      },
      err: (Failure failure) => state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    final Result<List<ProductEntity>> result =
        await _getProducts(limit: _pageSize, skip: _skip);
    state = result.when(
      ok: (List<ProductEntity> products) {
        _skip += products.length;
        return state.copyWith(
          products: <ProductEntity>[...state.products, ...products],
          isLoadingMore: false,
          hasReachedEnd: products.length < _pageSize,
        );
      },
      err: (Failure failure) => state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      ),
    );
  }
}

final StateNotifierProvider<ProductsListController, ProductsListState>
    productsListProvider =
    StateNotifierProvider<ProductsListController, ProductsListState>(
  (Ref ref) => ProductsListController(ref.watch(getProductsUseCaseProvider)),
);

final FutureProviderFamily<ProductEntity, int> productDetailProvider =
    FutureProvider.family<ProductEntity, int>((Ref ref, int id) async {
  final Result<ProductEntity> result =
      await ref.watch(getProductByIdUseCaseProvider)(id);
  return result.when(
    ok: (ProductEntity product) => product,
    err: (Failure failure) => throw Exception(failure.message),
  );
});

final StateProvider<String> productsSearchQueryProvider =
    StateProvider<String>((Ref ref) => '');

final FutureProviderFamily<List<ProductEntity>, String> productsSearchProvider =
    FutureProvider.family<List<ProductEntity>, String>((Ref ref, String query) async {
  final Result<List<ProductEntity>> result =
      await ref.watch(searchProductsUseCaseProvider)(query);
  return result.when(
    ok: (List<ProductEntity> products) => products,
    err: (Failure failure) => throw Exception(failure.message),
  );
});
