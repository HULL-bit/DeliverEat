import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../models/view_state.dart';
import '../../providers/auth_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../widgets/cart_badge.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/shimmer_loader.dart';
import '../restaurant/restaurant_detail_screen.dart';
import 'widgets/sort_sheet.dart';

/// Accueil : recherche débouncée, catégories, filtres, tri, liste de
/// restaurants paginée avec défilement infini et pull-to-refresh.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<RestaurantProvider>();
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
      provider.loadNextPage();
    }
    final shouldShow = _scrollController.offset > 400;
    if (shouldShow != _showScrollToTop) setState(() => _showScrollToTop = shouldShow);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = context.select<AuthProvider, String?>((a) => a.currentUser?.name);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<RestaurantProvider>().refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              titleSpacing: 20,
              title: Text(l10n.homeGreeting(user ?? '')),
              actions: [
                CartBadge(
                  child: IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.cart),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              sliver: SliverToBoxAdapter(
                child: _SearchField(controller: _searchController),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                height: 56,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const _CategoryRow(),
                ),
              ),
            ),
            SliverToBoxAdapter(child: const _FilterRow()),
            const _RecentSearches(),
            const _RestaurantListSliver(),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _showScrollToTop ? 1 : 0,
        child: FloatingActionButton.small(
          onPressed: () => _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic),
          child: const Icon(Icons.arrow_upward_rounded),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.homeSearchHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    controller.clear();
                    context.read<RestaurantProvider>().onSearchChanged('');
                  },
                ),
        ),
      ),
      onChanged: (value) => context.read<RestaurantProvider>().onSearchChanged(value),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final l10n = AppLocalizations.of(context);
    if (provider.search.isNotEmpty || provider.recentSearches.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.homeRecentSearches, style: Theme.of(context).textTheme.titleSmall),
                TextButton(onPressed: provider.clearRecentSearches, child: Text(l10n.homeClearSearches)),
              ],
            ),
            Wrap(
              spacing: 8,
              children: [
                for (final query in provider.recentSearches)
                  ActionChip(
                    label: Text(query),
                    onPressed: () => provider.onSearchChanged(query),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RestaurantProvider>().categoriesState;
    final selected = context.select<RestaurantProvider, String?>((p) => p.category);

    if (state.status != ViewStatus.success || state.data == null) {
      return const SizedBox.shrink();
    }
    final categories = state.data!;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, i) {
        if (i == 0) {
          return _CategoryChip(label: '${l10nAll(context)} 🍽️', selected: selected == null, onTap: () => context.read<RestaurantProvider>().setCategory(null));
        }
        final category = categories[i - 1];
        return _CategoryChip(
          label: '${category.name} ${category.emoji}',
          selected: selected == category.id,
          onTap: () => context.read<RestaurantProvider>().setCategory(category.id),
        );
      },
    );
  }

  String l10nAll(BuildContext context) => AppLocalizations.of(context).commonSeeAll;
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.homeOpenOnly),
            selected: provider.openOnly,
            onSelected: (v) => provider.setOpenOnly(v),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showSortSheet(context, currentSort: provider.sort, onSelected: provider.setSort),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.sort_rounded, size: 18),
                  const SizedBox(width: 4),
                  Text(l10n.homeSortLabel, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantListSliver extends StatelessWidget {
  const _RestaurantListSliver();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final state = provider.state;
    final l10n = AppLocalizations.of(context);

    if (state.status == ViewStatus.loading && provider.items.isEmpty) {
      return const SliverToBoxAdapter(child: RestaurantListShimmer());
    }
    if (state.status == ViewStatus.error && provider.items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorRetry(message: state.message ?? '', onRetry: () => provider.refresh()),
      );
    }
    if (provider.items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(icon: Icons.search_off_rounded, title: l10n.homeEmptyTitle, subtitle: l10n.homeEmptySubtitle),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      sliver: SliverList.separated(
        itemCount: provider.items.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          if (i == provider.items.length) {
            return provider.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          final restaurant = provider.items[i];
          return RestaurantCard(
            restaurant: restaurant,
            openBuilder: (context, close) => RestaurantDetailScreen(restaurantId: restaurant.id, heroRestaurant: restaurant),
          ).animate().fadeIn(delay: (30 * i).ms, duration: 300.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
        },
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => oldDelegate.child != child;
}
