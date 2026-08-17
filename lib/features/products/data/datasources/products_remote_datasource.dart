import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit, int skip});
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  const ProductsRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ProductModel>> getProducts({
    int limit = ApiConstants.defaultPageLimit,
    int skip = 0,
  }) async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>(
      ApiConstants.products,
      queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
    );
    return ProductModel.listFromJson(response.data!);
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>(ApiConstants.productById(id));
    return ProductModel.fromJson(response.data!);
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>(
      ApiConstants.productSearch,
      queryParameters: <String, dynamic>{'q': query},
    );
    return ProductModel.listFromJson(response.data!);
  }
}
