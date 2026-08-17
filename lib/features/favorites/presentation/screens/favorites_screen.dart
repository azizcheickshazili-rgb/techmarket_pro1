import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const String routeName = 'favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Set<int> favoriteIds = ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: favoriteIds.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.favorite_border_rounded,
                        size: 44, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(l10n.noFavorites, textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.66,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favoriteIds.length,
              itemBuilder: (BuildContext context, int index) {
                final int id = favoriteIds.elementAt(index);
                final AsyncValue<ProductEntity> productAsync =
                    ref.watch(productDetailProvider(id));
                return productAsync.when(
                  loading: () => const Card(child: LoadingIndicator()),
                  error: (Object error, _) => const SizedBox.shrink(),
                  data: (ProductEntity product) => ProductCard(
                    key: ValueKey<int>(product.id),
                    product: product,
                    isFavorite: true,
                    onTap: () => context.pushNamed(
                      'product-detail',
                      pathParameters: <String, String>{'id': product.id.toString()},
                    ),
                    onToggleFavorite: () => ref
                        .read(favoritesControllerProvider.notifier)
                        .toggle(product.id),
                  ),
                );
              },
            ),
    );
  }
}
