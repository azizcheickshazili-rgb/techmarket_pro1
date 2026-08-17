import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techmarket/core/utils/result.dart';
import 'package:techmarket/features/products/domain/entities/product_entity.dart';
import 'package:techmarket/features/products/domain/repositories/products_repository.dart';
import 'package:techmarket/features/products/domain/usecases/search_products_usecase.dart';

class _MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late _MockProductsRepository repository;
  late SearchProductsUseCase useCase;

  setUp(() {
    repository = _MockProductsRepository();
    useCase = SearchProductsUseCase(repository);
  });

  test('returns an empty Ok list without querying the repository for a blank query', () async {
    final Result<List<ProductEntity>> result = await useCase('   ');

    expect(result.isOk, isTrue);
    result.when(
      ok: (List<ProductEntity> products) => expect(products, isEmpty),
      err: (_) => fail('expected Ok'),
    );
    verifyNever(() => repository.searchProducts(any()));
  });

  test('delegates to repository.searchProducts with the trimmed query', () async {
    when(() => repository.searchProducts('phone'))
        .thenAnswer((_) async => const Result<List<ProductEntity>>.ok(<ProductEntity>[]));

    await useCase('  phone  ');

    verify(() => repository.searchProducts('phone')).called(1);
  });
}
