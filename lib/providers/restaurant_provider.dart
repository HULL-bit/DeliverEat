import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_exception.dart';
import '../models/category.dart';
import '../models/restaurant.dart';
import '../models/view_state.dart';
import '../services/restaurant_service.dart';

/// Catalogue : catégories, liste de restaurants paginée, recherche,
/// filtres et tri.
///
/// La recherche est débouncée ici (et non dans l'UI) : c'est une règle
/// métier de sobriété réseau (l'API limite à 120 req/min), pas un détail
/// de présentation.
class RestaurantProvider extends ChangeNotifier {
  RestaurantProvider(this._service, {required SharedPreferences prefs}) : _prefs = prefs {
    unawaited(loadCategories());
    unawaited(refresh());
  }
  
  final RestaurantService _service;
  final SharedPreferences _prefs;

  ViewState<List<Category>> _categoriesState = const ViewState.initial();
  ViewState<List<Category>> get categoriesState => _categoriesState;

  ViewState<List<Restaurant>> _state = const ViewState.initial();
  ViewState<List<Restaurant>> get state => _state;

  final List<Restaurant> _items = [];
  List<Restaurant> get items => List.unmodifiable(_items);

  int _page = 1;
  bool _hasNext = true;
  bool _loadingMore = false;
  bool get canLoadMore => _hasNext && !_loadingMore;
  bool get isLoadingMore => _loadingMore;

  bool _servedFromCache = false;
  bool get servedFromCache => _servedFromCache;

  String _search = '';
  String get search => _search;
  String? _category;
  String? get category => _category;
  bool _openOnly = false;
  bool get openOnly => _openOnly;
  String _sort = 'rating';
  String get sort => _sort;

  Timer? _debounce;

  List<String> get recentSearches => _prefs.getStringList(StorageKeys.recentSearches) ?? const [];

  Future<void> loadCategories() async {
    _categoriesState = const ViewState.loading();
    notifyListeners();
    try {
      final categories = await _service.getCategories();
      _categoriesState = ViewState.success(categories);
    } on ApiException catch (e) {
      _categoriesState = ViewState.error(e.message);
    }
    notifyListeners();
  }

  /// Débounce ~400ms avant de relancer la recherche.
  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppDurations.searchDebounce, () {
      _search = value.trim();
      unawaited(refresh());
      if (_search.isNotEmpty) unawaited(_rememberSearch(_search));
    });
  }

  void setCategory(String? categoryId) {
    if (_category == categoryId) return;
    _category = categoryId;
    unawaited(refresh());
  }

  void setOpenOnly(bool value) {
    if (_openOnly == value) return;
    _openOnly = value;
    unawaited(refresh());
  }

  void setSort(String sort) {
    if (_sort == sort) return;
    _sort = sort;
    unawaited(refresh());
  }

  Future<void> refresh() async {
    _page = 1;
    _hasNext = true;
    _servedFromCache = false;
    _state = ViewState.loading(data: _items.isEmpty ? null : _items);
    notifyListeners();
    try {
      final result = await _service.getRestaurants(
        search: _search,
        category: _category,
        open: _openOnly ? true : null,
        sort: _sort,
        page: _page,
        limit: AppSizes.defaultPageLimit,
      );
      _items
        ..clear()
        ..addAll(result.data);
      _hasNext = result.meta.hasNextPage;
      _state = ViewState.success(_items);
      if (_search.isEmpty && _category == null && !_openOnly) {
        await _cacheRestaurants(_items);
      }
    } on ApiException catch (e) {
      final cached = e.isNetworkError ? await _loadCachedRestaurants() : null;
      if (cached != null && cached.isNotEmpty) {
        _items
          ..clear()
          ..addAll(cached);
        _hasNext = false;
        _servedFromCache = true;
        _state = ViewState.success(_items);
      } else {
        _state = ViewState.error(e.message);
      }
    }
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (!canLoadMore) return;
    _loadingMore = true;
    notifyListeners();
    try {
      final result = await _service.getRestaurants(
        search: _search,
        category: _category,
        open: _openOnly ? true : null,
        sort: _sort,
        page: _page + 1,
        limit: AppSizes.defaultPageLimit,
      );
      _page += 1;
      _items.addAll(result.data);
      _hasNext = result.meta.hasNextPage;
    } on ApiException {
      // Silencieux : l'utilisateur peut retenter le scroll, la liste déjà
      // chargée reste affichée.
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  Future<void> _rememberSearch(String query) async {
    final current = List<String>.from(recentSearches)..remove(query);
    current.insert(0, query);
    await _prefs.setStringList(StorageKeys.recentSearches, current.take(8).toList());
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove(StorageKeys.recentSearches);
    notifyListeners();
  }

  Future<void> _cacheRestaurants(List<Restaurant> restaurants) async {
    final encoded = jsonEncode(restaurants
        .map((r) => {
              'id': r.id,
              'name': r.name,
              'description': r.description,
              'imageUrl': r.imagePath,
              'rating': r.rating,
              'ratingCount': r.ratingCount,
              'deliveryTimeMin': r.deliveryTimeMin,
              'deliveryTimeMax': r.deliveryTimeMax,
              'deliveryFee': r.deliveryFee,
              'isOpen': r.isOpen,
              'category': r.categoryId,
              'address': r.address,
            })
        .toList());
    await _prefs.setString(StorageKeys.cachedRestaurants, encoded);
  }

  Future<List<Restaurant>?> _loadCachedRestaurants() async {
    final raw = _prefs.getString(StorageKeys.cachedRestaurants);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
