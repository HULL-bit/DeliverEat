import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../models/restaurant.dart';
import '../models/view_state.dart';
import '../services/favorite_service.dart';
import 'auth_provider.dart';

/// Restaurants favoris de l'utilisateur, synchronisés avec l'API.
///
/// Se recharge automatiquement à la connexion et se vide à la déconnexion
/// via [updateAuth], appelé par le `ChangeNotifierProxyProvider` racine
/// (voir app.dart).
class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider(this._service);

  final FavoriteService _service;
  bool _authenticated = false;

  ViewState<List<Restaurant>> _state = const ViewState.initial();
  ViewState<List<Restaurant>> get state => _state;

  Set<String> get favoriteIds => (_state.data ?? const <Restaurant>[]).map((r) => r.id).toSet();
  bool isFavorite(String restaurantId) => favoriteIds.contains(restaurantId);

  void updateAuth(AuthProvider auth) {
    final wasAuthenticated = _authenticated;
    _authenticated = auth.isAuthenticated;
    if (_authenticated && !wasAuthenticated) {
      unawaited(load());
    } else if (!_authenticated && wasAuthenticated) {
      _state = const ViewState.initial();
      notifyListeners();
    }
  }

  Future<void> load() async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final favorites = await _service.getFavorites();
      _state = ViewState.success(favorites);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message, errorCode: e.code);
    }
    notifyListeners();
  }

  /// Ajoute/retire [restaurant] des favoris avec mise à jour optimiste ;
  /// en cas d'échec réseau, l'état est rechargé depuis l'API pour rester
  /// cohérent.
  Future<void> toggle(Restaurant restaurant) async {
    final wasFavorite = isFavorite(restaurant.id);
    final current = List<Restaurant>.from(_state.data ?? const <Restaurant>[]);
    if (wasFavorite) {
      current.removeWhere((r) => r.id == restaurant.id);
    } else {
      current.insert(0, restaurant);
    }
    _state = ViewState.success(current);
    notifyListeners();

    try {
      if (wasFavorite) {
        await _service.removeFavorite(restaurant.id);
      } else {
        await _service.addFavorite(restaurant.id);
      }
    } on ApiException {
      await load();
      rethrow;
    }
  }
}
