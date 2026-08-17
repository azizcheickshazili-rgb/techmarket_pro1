import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    required this.category,
    required this.thumbnail,
    this.images = const <String>[],
    this.discountPercentage = 0,
  });

  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final String category;
  final String thumbnail;
  final List<String> images;
  final double discountPercentage;

  double get discountedPrice => price - (price * discountPercentage / 100);

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        description,
        price,
        rating,
        stock,
        category,
        thumbnail,
        images,
        discountPercentage,
      ];
}
