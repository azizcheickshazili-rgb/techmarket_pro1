import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket/core/utils/result.dart';
import 'package:techmarket/features/products/data/datasources/products_remote_datasource.dart';
import 'package:techmarket/features/products/data/models/product_model.dart';
import 'package:techmarket/features/products/data/repositories/products_repository_impl.dart';
import 'package:techmarket/features/products/domain/entities/product_entity.dart';

class _MockProductsRemoteDataSource extends Mock implements ProductsRemoteDataSource {}

void main() {
  late _MockProductsRemoteDataSource remoteDataSource;
  late ProductsRepositoryImpl repository;

  const ProductModel fakeProduct = ProductModel(
    id: 1,
    title: 'iPhone 9',
    description: 'An apple mobile',
    price: 549,
    rating: 4.69,
    stock: 94,
    category: 'smartphones',
    thumbnail: 'https://cdn.dummyjson.com/products/images/1/1.jpg',
  );

  setUp(() {
    remoteDataSource = _MockProductsRemoteDataSource();
    repository = ProductsRepositoryImpl(remoteDataSource);
  });

  group('ProductsRepositoryImpl.getProducts', () {
    test('returns Ok(list) on success', () async {
      when(() => remoteDataSource.getProducts(limit: any(named: 'limit'), skip: any(named: 'skip')))
          .thenAnswer((_) async => <ProductModel>[fakeProduct]);

      final Result<List<ProductEntity>> result = await repository.getProducts();

      expect(result.isOk, isTrue);
      result.when(
        ok: (List<ProductEntity> products) => expect(products.single.title, 'iPhone 9'),
        err: (_) => fail('expected Ok'),
      );
    });

    test('maps server errors (5xx) to ServerFailure with status code', () async {
      when(() => remoteDataSource.getProducts(limit: any(named: 'limit'), skip: any(named: 'skip')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/products'),
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: '/products'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      ));

      final Result<List<ProductEntity>> result = await repository.getProducts();

      result.when(
        ok: (_) => fail('expected Err'),
        err: (Failure failure) {
          expect(failure, isA<ServerFailure>());
          expect((failure as ServerFailure).statusCode, 500);
        },
      );
    });
  });

  group('ProductsRepositoryImpl.getProductById', () {
    test('returns Ok(product) on success', () async {
      when(() => remoteDataSource.getProductById(1)).thenAnswer((_) async => fakeProduct);

      final Result<ProductEntity> result = await repository.getProductById(1);

      expect(result.isOk, isTrue);
    });
  });
}
