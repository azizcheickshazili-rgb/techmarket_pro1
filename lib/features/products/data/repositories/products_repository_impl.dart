import 'package:dio/dio.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl(this._remoteDataSource);

  final ProductsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<ProductEntity>>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final List<ProductEntity> products = await _remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return Result<List<ProductEntity>>.ok(products);
    } on DioException catch (error) {
      return Result<List<ProductEntity>>.err(_mapDioError(error));
    } catch (_) {
      return const Result<List<ProductEntity>>.err(UnknownFailure());
    }
  }

  @override
  Future<Result<ProductEntity>> getProductById(int id) async {
    try {
      final ProductEntity product = await _remoteDataSource.getProductById(id);
      return Result<ProductEntity>.ok(product);
    } on DioException catch (error) {
      return Result<ProductEntity>.err(_mapDioError(error));
    } catch (_) {
      return const Result<ProductEntity>.err(UnknownFailure());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> searchProducts(String query) async {
    try {
      final List<ProductEntity> products =
          await _remoteDataSource.searchProducts(query);
      return Result<List<ProductEntity>>.ok(products);
    } on DioException catch (error) {
      return Result<List<ProductEntity>>.err(_mapDioError(error));
    } catch (_) {
      return const Result<List<ProductEntity>>.err(UnknownFailure());
    }
  }

  Failure _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkFailure();
    }
    return ServerFailure(
      error.message ?? 'Erreur serveur.',
      statusCode: error.response?.statusCode,
    );
  }
}
