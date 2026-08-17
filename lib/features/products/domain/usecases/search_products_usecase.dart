import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class SearchProductsUseCase {
  const SearchProductsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Result<List<ProductEntity>>> call(String query) {
    final String trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Future<Result<List<ProductEntity>>>.value(
        const Result<List<ProductEntity>>.ok(<ProductEntity>[]),
      );
    }
    return _repository.searchProducts(trimmed);
  }
}
