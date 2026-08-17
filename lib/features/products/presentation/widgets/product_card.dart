import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/product_entity.dart';

/// Const-constructible card so `ListView.builder`/`GridView.builder`
/// don't rebuild items whose data hasn't changed — combined with
/// `cached_network_image`'s built-in disk cache this keeps scrolling
/// at 60fps even on long catalogues.
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    super.key,
  });

  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${product.title}, ${product.discountedPrice.toStringAsFixed(2)} dollars',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const Key('product_card_tap_area'),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      memCacheWidth: 400,
                      placeholder: (BuildContext context, String url) =>
                          const ColoredBox(color: AppColors.navySurfaceElevated),
                      errorWidget: (BuildContext context, String url, Object error) =>
                          const ColoredBox(
                        color: AppColors.navySurfaceElevated,
                        child: Icon(Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Semantics(
                        button: true,
                        label: isFavorite
                            ? 'Retirer des favoris'
                            : 'Ajouter aux favoris',
                        child: Material(
                          color: Colors.black45,
                          shape: const CircleBorder(),
                          child: IconButton(
                            iconSize: 20,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? AppColors.danger
                                  : Colors.white,
                            ),
                            onPressed: onToggleFavorite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          '\$${product.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.cyanAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFFFC857)),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
