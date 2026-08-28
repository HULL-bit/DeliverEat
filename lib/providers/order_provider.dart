import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_exception.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/view_state.dart';
import '../services/order_service.dart';
import 'auth_provider.dart';

/// Historique des commandes de l'utilisateur (paginé, filtrable par statut)
/// et point d'entrée pour créer/annuler une commande.
class OrderProvider extends ChangeNotifier {
  OrderProvider(this._service);

  final OrderService _service;
  bool _authenticated = false;

  ViewState<List<Order>> _state = const ViewState.initial();
  ViewState<List<Order>> get state => _state;

  final List<Order> _items = [];
  List<Order> get items => List.unmodifiable(_items);

  int _page = 1;
  bool _hasNext = true;
  bool _loadingMore = false;
  bool get canLoadMore => _hasNext && !_loadingMore;
  bool get isLoadingMore => _loadingMore;

  String? _statusFilter;
  String? get statusFilter => _statusFilter;

  void updateAuth(AuthProvider auth) {
    final wasAuthenticated = _authenticated;
    _authenticated = auth.isAuthenticated;
    if (_authenticated && !wasAuthenticated) {
      unawaited(refresh());
    } else if (!_authenticated && wasAuthenticated) {
      _items.clear();
      _state = const ViewState.initial();
      notifyListeners();
    }
  }

  void setStatusFilter(String? status) {
    if (_statusFilter == status) return;
    _statusFilter = status;
    unawaited(refresh());
  }

  Future<void> refresh() async {
    _page = 1;
    _hasNext = true;
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final result = await _service.getOrders(status: _statusFilter, page: _page, limit: AppSizes.defaultPageLimit);
      _items
        ..clear()
        ..addAll(result.data);
      _hasNext = result.meta.hasNextPage;
      _state = ViewState.success(_items);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message, errorCode: e.code);
    }
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (!canLoadMore) return;
    _loadingMore = true;
    notifyListeners();
    try {
      final result =
          await _service.getOrders(status: _statusFilter, page: _page + 1, limit: AppSizes.defaultPageLimit);
      _page += 1;
      _items.addAll(result.data);
      _hasNext = result.meta.hasNextPage;
    } on ApiException {
      // La liste déjà chargée reste affichée ; l'utilisateur peut retenter.
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  /// Crée une commande. Les erreurs (422 RESTAURANT_CLOSED, VALIDATION_ERROR)
  /// remontent telles quelles à l'appelant (écran de checkout) pour un
  /// affichage contextuel.
  Future<Order> createOrder({
    required String restaurantId,
    required List<OrderItem> items,
    required String deliveryAddress,
    String? notes,
  }) async {
    final order = await _service.createOrder(
      restaurantId: restaurantId,
      items: items,
      deliveryAddress: deliveryAddress,
      notes: notes,
    );
    _items.insert(0, order);
    _state = ViewState.success(_items);
    notifyListeners();
    return order;
  }

  /// Annule une commande. Propage 422 CANNOT_CANCEL à l'appelant.
  Future<Order> cancelOrder(String id) async {
    final cancelled = await _service.cancelOrder(id);
    final index = _items.indexWhere((o) => o.id == id);
    if (index != -1) _items[index] = cancelled;
    _state = ViewState.success(_items);
    notifyListeners();
    return cancelled;
  }

  Future<Order> fetchDetail(String id) => _service.getOrderDetail(id);
}
