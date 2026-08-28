import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../models/view_state.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_tracking_provider.dart';
import '../../services/order_service.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/status_timeline.dart';

/// Suivi en direct d'une commande (WebSocket + repli polling), avec bouton
/// d'annulation contextuel et notifications locales à chaque changement de
/// statut.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => OrderTrackingProvider(
        orderService: c.read<OrderService>(),
        secureStorage: c.read<SecureStorage>(),
        ensureFreshToken: c.read<AuthProvider>().ensureFreshToken,
      )..track(orderId),
      child: const _OrderTrackingView(),
    );
  }
}

class _OrderTrackingView extends StatefulWidget {
  const _OrderTrackingView();

  @override
  State<_OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<_OrderTrackingView> {
  bool _callbackWired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_callbackWired) return;
    _callbackWired = true;
    final l10n = AppLocalizations.of(context);
    final notificationService = context.read<NotificationService>();
    context.read<OrderTrackingProvider>().onStatusChanged = (order, previousStatus) {
      notificationService.notifyOrderStatusChange(
        title: l10n.notifOrderUpdateTitle,
        body: l10n.notifOrderUpdateBody(order.displayNumber, _statusLabel(l10n, order.status)),
      );
    };
  }

  @override
  void dispose() {
    context.read<OrderTrackingProvider>().stop();
    super.dispose();
  }

  String _statusLabel(AppLocalizations l10n, OrderStatus status) => switch (status) {
        OrderStatus.pending => l10n.orderStatusPending,
        OrderStatus.confirmed => l10n.orderStatusConfirmed,
        OrderStatus.preparing => l10n.orderStatusPreparing,
        OrderStatus.delivering => l10n.orderStatusDelivering,
        OrderStatus.delivered => l10n.orderStatusDelivered,
        OrderStatus.cancelled => l10n.orderStatusCancelled,
      };

  Future<void> _cancel() async {
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
      await context.read<OrderTrackingProvider>().cancelOrder();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<OrderTrackingProvider>().state;
    final isLive = context.watch<OrderTrackingProvider>().isLive;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderTrackingTitle)),
      body: switch (state.status) {
        ViewStatus.loading when state.data == null => const Center(child: CircularProgressIndicator()),
        ViewStatus.error when state.data == null => ErrorRetry(
            message: ErrorMessages.resolve(context, code: state.errorCode, fallback: state.message ?? ''),
            onRetry: () => context.read<OrderTrackingProvider>().retry(),
          ),
        _ when state.data != null => _Content(order: state.data!, isLive: isLive, onCancel: _cancel),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.order, required this.isLive, required this.onCancel});

  final Order order;
  final bool isLive;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Text(l10n.orderNumber(order.displayNumber), style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Icon(isLive ? Icons.wifi_rounded : Icons.wifi_off_rounded, size: 16, color: isLive ? scheme.secondary : scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              isLive ? l10n.orderTrackingLive : l10n.orderTrackingOffline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isLive ? scheme.secondary : scheme.onSurfaceVariant),
            ),
          ],
        ),
        if (order.estimatedDeliveryAt != null &&
            order.status != OrderStatus.delivered &&
            order.status != OrderStatus.cancelled) ...[
          const SizedBox(height: 12),
          _EtaCountdown(estimatedDeliveryAt: order.estimatedDeliveryAt!),
        ],
        const SizedBox(height: 24),
        StatusTimeline(status: order.status, history: order.statusHistory),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.restaurantName ?? '', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                for (final item in order.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${item.quantity}× ${item.name}'),
                  ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.cartTotal, style: Theme.of(context).textTheme.titleSmall),
                    Text(Formatters.priceFcfa(order.total), style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (order.status == OrderStatus.pending) ...[
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(foregroundColor: scheme.error, side: BorderSide(color: scheme.error)),
            child: Text(l10n.orderCancelButton),
          ),
        ],
      ],
    );
  }
}

/// Compte à rebours jusqu'à l'heure de livraison estimée renvoyée par
/// l'API (estimatedDeliveryAt), rafraîchi chaque minute.
class _EtaCountdown extends StatefulWidget {
  const _EtaCountdown({required this.estimatedDeliveryAt});

  final DateTime estimatedDeliveryAt;

  @override
  State<_EtaCountdown> createState() => _EtaCountdownState();
}

class _EtaCountdownState extends State<_EtaCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final remaining = widget.estimatedDeliveryAt.difference(DateTime.now());
    final minutes = remaining.inMinutes;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: scheme.tertiaryContainer, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: scheme.onTertiaryContainer),
          const SizedBox(width: 10),
          Text(
            minutes > 0 ? l10n.orderEtaMinutes(minutes) : l10n.orderEtaImminent,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: scheme.onTertiaryContainer),
          ),
        ],
      ),
    );
  }
}
