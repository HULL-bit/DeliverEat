import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../models/view_state.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/restaurant_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/shimmer_loader.dart';

/// Historique des commandes, filtrable par statut, avec annulation (si
/// `pending`) et "recommander en un tap".
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent - 300) {
        context.read<OrderProvider>().loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cancelOrder(Order order) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.orderCancelConfirmTitle),
        content: Text(l10n.orderCancelConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.commonConfirm)),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await context.read<OrderProvider>().cancelOrder(order.id);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
    }
  }

  Future<void> _reorder(Order order) async {
    try {
      final restaurant = await context.read<RestaurantService>().getRestaurantDetail(order.restaurantId);
      if (!mounted) return;
      context.read<CartProvider>().loadFromOrder(order, deliveryFee: restaurant.deliveryFee);
      Navigator.of(context).pushNamed(AppRoutes.cart);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<OrderProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ordersTitle)),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: l10n.ordersFilterAll, selected: provider.statusFilter == null, onTap: () => provider.setStatusFilter(null)),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.orderStatusPending, selected: provider.statusFilter == 'pending', onTap: () => provider.setStatusFilter('pending')),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.orderStatusPreparing, selected: provider.statusFilter == 'preparing', onTap: () => provider.setStatusFilter('preparing')),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.orderStatusDelivering, selected: provider.statusFilter == 'delivering', onTap: () => provider.setStatusFilter('delivering')),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.orderStatusDelivered, selected: provider.statusFilter == 'delivered', onTap: () => provider.setStatusFilter('delivered')),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.orderStatusCancelled, selected: provider.statusFilter == 'cancelled', onTap: () => provider.setStatusFilter('cancelled')),
              ],
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (state.status == ViewStatus.loading && provider.items.isEmpty) {
                return const RestaurantListShimmer();
              }
              if (state.status == ViewStatus.error && provider.items.isEmpty) {
                return ErrorRetry(message: state.message ?? '', onRetry: provider.refresh);
              }
              if (provider.items.isEmpty) {
                return EmptyState(icon: Icons.receipt_long_outlined, title: l10n.ordersEmptyTitle, subtitle: l10n.ordersEmptySubtitle);
              }
              return RefreshIndicator(
                onRefresh: provider.refresh,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final order = provider.items[i];
                    return _OrderCard(
                      order: order,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.orderTracking, arguments: order.id),
                      onCancel: order.canCancel ? () => _cancelOrder(order) : null,
                      onReorder: () => _reorder(order),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
        child: ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap()),
      );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap, required this.onCancel, required this.onReorder});

  final Order order;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback onReorder;

  Color _statusColor(BuildContext context, OrderStatus status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      OrderStatus.delivered => scheme.secondary,
      OrderStatus.cancelled => scheme.error,
      _ => scheme.tertiary,
    };
  }

  String _statusLabel(AppLocalizations l10n, OrderStatus status) => switch (status) {
        OrderStatus.pending => l10n.orderStatusPending,
        OrderStatus.confirmed => l10n.orderStatusConfirmed,
        OrderStatus.preparing => l10n.orderStatusPreparing,
        OrderStatus.delivering => l10n.orderStatusDelivering,
        OrderStatus.delivered => l10n.orderStatusDelivered,
        OrderStatus.cancelled => l10n.orderStatusCancelled,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(order.restaurantName ?? order.displayNumber, style: Theme.of(context).textTheme.titleSmall)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: _statusColor(context, order.status).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(_statusLabel(l10n, order.status), style: TextStyle(color: _statusColor(context, order.status), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(Formatters.dateTime(order.createdAt), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(Formatters.priceFcfa(order.total), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(onPressed: onReorder, icon: const Icon(Icons.replay_rounded, size: 18), label: Text(l10n.orderReorder)),
                  if (onCancel != null)
                    TextButton(onPressed: onCancel, style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error), child: Text(l10n.orderCancelButton)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
