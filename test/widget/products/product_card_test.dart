import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techmarket_pro1/features/products/domain/entities/product_entity.dart';
import 'package:techmarket_pro1/features/products/presentation/widgets/product_card.dart';

void main() {
  const ProductEntity product = ProductEntity(
    id: 1,
    title: 'iPhone 9',
    description: 'A phone',
    price: 549,
    rating: 4.7,
    stock: 10,
    category: 'smartphones',
    thumbnail: 'https://cdn.dummyjson.com/products/images/1/1.jpg',
  );

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('ProductCard displays the product title and price',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(ProductCard(
        product: product,
        isFavorite: false,
        onTap: () {},
        onToggleFavorite: () {},
      )),
    );

    expect(find.text('iPhone 9'), findsOneWidget);
    expect(find.textContaining('549.00'), findsOneWidget);
  });

  testWidgets('ProductCard invokes onTap when the card is tapped',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      wrap(ProductCard(
        product: product,
        isFavorite: false,
        onTap: () => tapped = true,
        onToggleFavorite: () {},
      )),
    );

    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('ProductCard invokes onToggleFavorite when the heart icon is tapped',
      (WidgetTester tester) async {
    bool toggled = false;

    await tester.pumpWidget(
      wrap(ProductCard(
        product: product,
        isFavorite: false,
        onTap: () {},
        onToggleFavorite: () => toggled = true,
      )),
    );

    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    expect(toggled, isTrue);
  });

  testWidgets('ProductCard shows a filled heart icon when isFavorite is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(ProductCard(
        product: product,
        isFavorite: true,
        onTap: () {},
        onToggleFavorite: () {},
      )),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });
}
