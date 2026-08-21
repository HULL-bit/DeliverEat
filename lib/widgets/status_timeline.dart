import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../core/l10n/gen/app_localizations.dart';
import '../models/order_status.dart';
import '../models/status_history.dart';

/// Frise de progression d'une commande : étapes franchies cochées, étape
/// courante pulsante, horodatages relatifs pour chaque étape déjà atteinte.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.status, required this.history});

  final OrderStatus status;
  final List<StatusHistoryEntry> history;

  static const _steps = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.delivering,
    OrderStatus.delivered,
  ];

  String _label(AppLocalizations l10n, OrderStatus s) => switch (s) {
        OrderStatus.pending => l10n.orderStatusPending,
        OrderStatus.confirmed => l10n.orderStatusConfirmed,
        OrderStatus.preparing => l10n.orderStatusPreparing,
        OrderStatus.delivering => l10n.orderStatusDelivering,
        OrderStatus.delivered => l10n.orderStatusDelivered,
        OrderStatus.cancelled => l10n.orderStatusCancelled,
      };

  DateTime? _timestampFor(OrderStatus s) {
    for (final entry in history) {
      if (entry.status == s) return entry.timestamp;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    if (status == OrderStatus.cancelled) {
      return Row(
        children: [
          Icon(Icons.cancel_rounded, color: scheme.error),
          const SizedBox(width: 10),
          Text(l10n.orderStatusCancelled, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.error)),
        ],
      );
    }

    final currentIndex = status.stepIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++)
          _StepRow(
            label: _label(l10n, _steps[i]),
            timestamp: _timestampFor(_steps[i]),
            isDone: i < currentIndex,
            isCurrent: i == currentIndex,
            isLast: i == _steps.length - 1,
            locale: locale,
          ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.timestamp,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
    required this.locale,
  });

  final String label;
  final DateTime? timestamp;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reached = isDone || isCurrent;
    final color = reached ? scheme.secondary : scheme.outlineVariant;

    Widget dot = Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isDone ? scheme.secondary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: isDone
          ? Icon(Icons.check_rounded, size: 16, color: scheme.onSecondary)
          : isCurrent
              ? Center(child: Container(width: 8, height: 8, decoration: BoxDecoration(color: scheme.secondary, shape: BoxShape.circle)))
              : null,
    );

    if (isCurrent && !MediaQuery.of(context).disableAnimations) {
      dot = dot.animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.18, 1.18),
            duration: 700.ms,
            curve: Curves.easeInOut,
          );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              dot,
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: isDone ? scheme.secondary : scheme.outlineVariant),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: reached ? scheme.onSurface : scheme.onSurfaceVariant,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                        ),
                  ),
                  if (timestamp != null)
                    Text(
                      timeago.format(timestamp!, locale: locale),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ).animate().fadeIn(duration: 250.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
