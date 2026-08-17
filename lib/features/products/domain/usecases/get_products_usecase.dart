import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Result<List<ProductEntity>>> call({int limit = 20, int skip = 0}) {
    return _repository.getProducts(limit: limit, skip: skip);
  }
}
