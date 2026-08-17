import '../../../../core/utils/result.dart';
import '../entities/product_entity.dart';

abstract interface class ProductsRepository {
  Future<Result<List<ProductEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
  });

  Future<Result<ProductEntity>> getProductById(int id);

  Future<Result<List<ProductEntity>>> searchProducts(String query);
}
