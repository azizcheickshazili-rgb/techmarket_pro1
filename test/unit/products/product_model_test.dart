import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket/features/products/data/models/product_model.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('parses a single product payload', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'id': 1,
        'title': 'iPhone 9',
        'description': 'An apple mobile which is nothing like apple',
        'price': 549,
        'rating': 4.69,
        'stock': 94,
        'category': 'smartphones',
        'thumbnail': 'https://cdn.dummyjson.com/products/images/1/1.jpg',
        'images': <String>['https://cdn.dummyjson.com/products/images/1/1.jpg'],
        'discountPercentage': 12.96,
      };

      final ProductModel model = ProductModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'iPhone 9');
      expect(model.images, hasLength(1));
    });

    test('computes discountedPrice correctly', () {
      const ProductModel model = ProductModel(
        id: 1,
        title: 'Test',
        description: 'Test',
        price: 100,
        rating: 4.5,
        stock: 10,
        category: 'test',
        thumbnail: 'url',
        discountPercentage: 10,
      );

      expect(model.discountedPrice, 90);
    });
  });

  group('ProductModel.listFromJson', () {
    test('parses the DummyJSON /products envelope into a list', () {
      final Map<String, dynamic> json = <String, dynamic>{
        'products': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 1,
            'title': 'A',
            'description': 'a',
            'price': 10,
            'rating': 4,
            'stock': 5,
            'category': 'c',
            'thumbnail': 'u',
          },
          <String, dynamic>{
            'id': 2,
            'title': 'B',
            'description': 'b',
            'price': 20,
            'rating': 3,
            'stock': 8,
            'category': 'c',
            'thumbnail': 'u',
          },
        ],
        'total': 2,
        'skip': 0,
        'limit': 20,
      };

      final List<ProductModel> models = ProductModel.listFromJson(json);

      expect(models, hasLength(2));
      expect(models.first.title, 'A');
    });

    test('returns an empty list when the products key is missing', () {
      final List<ProductModel> models = ProductModel.listFromJson(<String, dynamic>{});
      expect(models, isEmpty);
    });
  });
}
