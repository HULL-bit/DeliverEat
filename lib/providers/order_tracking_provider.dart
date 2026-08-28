import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_exception.dart';
import '../core/storage/secure_storage.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/view_state.dart';
import '../services/order_service.dart';
import '../services/order_socket.dart';

/// Suivi en direct d'une commande unique.
///
/// Se connecte au WebSocket de commande et retombe automatiquement sur un
/// polling REST (`GET /orders/:id`) tant que la connexion live est
/// indisponible, sans jamais laisser l'écran figé. [onStatusChanged] est un
/// point d'extension (branché par l'écran) pour déclencher une notification
/// locale localisée à chaque transition de statut.
class OrderTrackingProvider extends ChangeNotifier {
  OrderTrackingProvider({
    required OrderService orderService,
    required SecureStorage secureStorage,
    required Future<void> Function() ensureFreshToken,
  }) : _orderService = orderService {
    _socket = OrderSocket(secureStorage: secureStorage, ensureFreshToken: ensureFreshToken);
  }

  final OrderService _orderService;
  late final OrderSocket _socket;

  StreamSubscription<SocketConnectionStatus>? _statusSub;
  StreamSubscription<Map<String, dynamic>>? _messageSub;
  Timer? _pollTimer;
  String? _orderId;

  ViewState<Order> _state = const ViewState.initial();
  ViewState<Order> get state => _state;

  bool _isLive = false;
  bool get isLive => _isLive;

  /// Appelé (par l'écran) à chaque transition de statut détectée, pour
  /// notifier l'utilisateur avec un texte déjà localisé.
  void Function(Order order, OrderStatus previousStatus)? onStatusChanged;

  /// Relance le suivi de la même commande après une erreur (bouton
  /// "Réessayer"). Sans effet si aucune commande n'a encore été demandée.
  Future<void> retry() async {
    final id = _orderId;
    if (id != null) await track(id);
  }

  Future<void> track(String orderId) async {
    _orderId = orderId;
    _state = const ViewState.loading();
    notifyListeners();

    try {
      final order = await _orderService.getOrderDetail(orderId);
      _state = ViewState.success(order);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message, errorCode: e.code);
      notifyListeners();
      return;
    }
    notifyListeners();

    _statusSub = _socket.statusStream.listen(_onSocketStatus);
    _messageSub = _socket.messages.listen(_onSocketMessage);
    unawaited(_socket.connect());
  }

  void _onSocketStatus(SocketConnectionStatus status) {
    _isLive = status == SocketConnectionStatus.connected;
    if (_isLive) {
      _stopPolling();
    } else {
      _startPolling();
    }
    notifyListeners();
  }

  void _onSocketMessage(Map<String, dynamic> message) {
    if (message['type'] != 'order_update') return;
    final orderJson = message['order'];
    if (orderJson is! Map<String, dynamic>) return;
    _applyUpdatedOrder(Order.fromJson(orderJson));
  }

  void _startPolling() {
    if (_pollTimer != null || _orderId == null) return;
    _pollTimer = Timer.periodic(AppDurations.wsPollingFallback, (_) => _pollOnce());
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _pollOnce() async {
    final id = _orderId;
    if (id == null) return;
    try {
      final order = await _orderService.getOrderDetail(id);
      _applyUpdatedOrder(order);
    } on ApiException {
      // Erreur transitoire : on retentera au prochain cycle de polling.
    }
  }

  void _applyUpdatedOrder(Order updated) {
    if (updated.id != _orderId) return;
    final previousStatus = _state.data?.status;
    _state = ViewState.success(updated);
    notifyListeners();
    if (previousStatus != null && previousStatus != updated.status) {
      onStatusChanged?.call(updated, previousStatus);
    }
  }

  Future<Order> cancelOrder() async {
    final id = _orderId;
    if (id == null) throw StateError('Aucune commande suivie.');
    final cancelled = await _orderService.cancelOrder(id);
    _applyUpdatedOrder(cancelled);
    return cancelled;
  }

  Future<void> stop() async {
    await _statusSub?.cancel();
    await _messageSub?.cancel();
    _statusSub = null;
    _messageSub = null;
    _stopPolling();
    await _socket.disconnect();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _messageSub?.cancel();
    _pollTimer?.cancel();
    _socket.dispose();
    super.dispose();
  }
}
