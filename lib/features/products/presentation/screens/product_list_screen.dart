import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends HookConsumerWidget {
  const ProductListScreen({super.key});

  static const String routeName = 'products';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ScrollController scrollController = useScrollController();
    final ValueNotifier<String> query = useState<String>('');

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 300) {
          ref.read(productsListProvider.notifier).loadMore();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, <Object?>[scrollController]);

    final ProductsListState listState = ref.watch(productsListProvider);
    final Set<int> favorites = ref.watch(favoritesControllerProvider);
    final bool isSearching = query.value.trim().isNotEmpty;
    final AsyncValue<List<ProductEntity>>? searchResult =
        isSearching ? ref.watch(productsSearchProvider(query.value.trim())) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: l10n.profileTitle,
            onPressed: () => context.pushNamed('profile'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Semantics(
              textField: true,
              label: l10n.searchHint,
              child: TextField(
                key: const Key('product_search_field'),
                onChanged: (String value) => query.value = value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: l10n.searchHint,
                ),
              ),
            ),
          ),
          Expanded(
            child: isSearching
                ? _SearchResults(
                    result: searchResult!,
                    favorites: favorites,
                    l10n: l10n,
                  )
                : _ProductGrid(
                    state: listState,
                    favorites: favorites,
                    scrollController: scrollController,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({
    required this.state,
    required this.favorites,
    required this.scrollController,
  });

  final ProductsListState state;
  final Set<int> favorites;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.products.isEmpty) {
      return const LoadingIndicator();
    }
    if (state.errorMessage != null && state.products.isEmpty) {
      return ErrorView(
        message: state.errorMessage!,
        onRetry: () => ref.read(productsListProvider.notifier).loadFirstPage(),
      );
    }
    return RefreshIndicator(
      onRefresh: () => ref.read(productsListProvider.notifier).loadFirstPage(),
      child: GridView.builder(
        key: const Key('product_grid'),
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.66,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index >= state.products.length) {
            return const Card(child: LoadingIndicator());
          }
          final ProductEntity product = state.products[index];
          return ProductCard(
            key: ValueKey<int>(product.id),
            product: product,
            isFavorite: favorites.contains(product.id),
            onTap: () => context.pushNamed(
              'product-detail',
              pathParameters: <String, String>{'id': product.id.toString()},
            ),
            onToggleFavorite: () =>
                ref.read(favoritesControllerProvider.notifier).toggle(product.id),
          );
        },
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.result,
    required this.favorites,
    required this.l10n,
  });

  final AsyncValue<List<ProductEntity>> result;
  final Set<int> favorites;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return result.when(
      loading: () => const LoadingIndicator(),
      error: (Object error, _) => ErrorView(message: l10n.genericError),
      data: (List<ProductEntity> products) {
        if (products.isEmpty) {
          return const Center(child: Text('Aucun résultat.'));
        }
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.66,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductEntity product = products[index];
                return ProductCard(
                  key: ValueKey<int>(product.id),
                  product: product,
                  isFavorite: favorites.contains(product.id),
                  onTap: () => context.pushNamed(
                    'product-detail',
                    pathParameters: <String, String>{'id': product.id.toString()},
                  ),
                  onToggleFavorite: () => ref
                      .read(favoritesControllerProvider.notifier)
                      .toggle(product.id),
                );
              },
            );
          },
        );
      },
    );
  }
}
