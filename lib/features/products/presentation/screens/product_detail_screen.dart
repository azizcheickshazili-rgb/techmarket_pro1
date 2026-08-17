import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  static const String routeName = 'product-detail';
  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<ProductEntity> productAsync =
        ref.watch(productDetailProvider(productId));
    final bool isFavorite =
        ref.watch(favoritesControllerProvider).contains(productId);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Semantics(
            button: true,
            label: isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? AppColors.danger : null,
              ),
              onPressed: () =>
                  ref.read(favoritesControllerProvider.notifier).toggle(productId),
            ),
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const LoadingIndicator(),
        error: (Object error, _) => ErrorView(
          message: l10n.genericError,
          onRetry: () => ref.refresh(productDetailProvider(productId)),
        ),
        data: (ProductEntity product) => _ProductDetailBody(product: product, l10n: l10n),
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.product, required this.l10n});

  final ProductEntity product;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            label: 'Photo du produit ${product.title}',
            image: true,
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) =>
                    const ColoredBox(color: AppColors.navySurfaceElevated),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(product.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.cyanAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (product.discountPercentage > 0) ...<Widget>[
                      const SizedBox(width: 10),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: <Widget>[
                    _InfoChip(
                        icon: Icons.star_rounded,
                        label: '${l10n.ratingLabel}: ${product.rating}'),
                    _InfoChip(
                        icon: Icons.inventory_2_outlined,
                        label: '${l10n.stockLabel}: ${product.stock}'),
                    _InfoChip(icon: Icons.category_outlined, label: product.category),
                  ],
                ),
                const SizedBox(height: 28),
                Semantics(
                  button: true,
                  label: l10n.addedToCart,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.addedToCart)),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_checkout_rounded),
                    label: const Text('Ajouter au panier'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.navySurfaceElevated,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
