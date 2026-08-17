import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._repository);

  final ProductsRepository _repository;

  Future<Result<ProductEntity>> call(int id) => _repository.getProductById(id);
}
