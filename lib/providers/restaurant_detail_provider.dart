import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/network/api_exception.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/view_state.dart';
import '../services/restaurant_service.dart';

/// État d'une fiche restaurant : détail (avec menu) + avis paginés.
///
/// Instancié à l'échelle de l'écran (un par restaurant consulté), pas à la
/// racine : c'est un état éphémère propre à une navigation, pas un état
/// partagé global.
class RestaurantDetailProvider extends ChangeNotifier {
  RestaurantDetailProvider(this._service, {required String restaurantId}) : _restaurantId = restaurantId {
    unawaited(reload());
    unawaited(loadReviews());
  }

  final RestaurantService _service;
  final String _restaurantId;

  ViewState<Restaurant> _detailState = const ViewState.initial();
  ViewState<Restaurant> get detailState => _detailState;

  ViewState<List<Review>> _reviewsState = const ViewState.initial();
  ViewState<List<Review>> get reviewsState => _reviewsState;

  final List<Review> _reviews = [];
  List<Review> get reviews => List.unmodifiable(_reviews);

  int _page = 1;
  bool _hasNextReviews = true;
  bool _loadingMoreReviews = false;
  bool get canLoadMoreReviews => _hasNextReviews && !_loadingMoreReviews;

  bool _submittingReview = false;
  bool get submittingReview => _submittingReview;

  Future<void> reload() async {
    _detailState = const ViewState.loading();
    notifyListeners();
    try {
      final restaurant = await _service.getRestaurantDetail(_restaurantId);
      _detailState = ViewState.success(restaurant);
    } on ApiException catch (e) {
      _detailState = ViewState.error(e.message, errorCode: e.code);
    }
    notifyListeners();
  }

  Future<void> loadReviews() async {
    _reviewsState = const ViewState.loading();
    notifyListeners();
    try {
      final result = await _service.getReviews(_restaurantId, page: 1, limit: AppSizes.defaultPageLimit);
      _page = 1;
      _reviews
        ..clear()
        ..addAll(result.data);
      _hasNextReviews = result.meta.hasNextPage;
      _reviewsState = ViewState.success(_reviews);
    } on ApiException catch (e) {
      _reviewsState = ViewState.error(e.message, errorCode: e.code);
    }
    notifyListeners();
  }

  Future<void> loadMoreReviews() async {
    if (!canLoadMoreReviews) return;
    _loadingMoreReviews = true;
    notifyListeners();
    try {
      final result = await _service.getReviews(_restaurantId, page: _page + 1, limit: AppSizes.defaultPageLimit);
      _page += 1;
      _reviews.addAll(result.data);
      _hasNextReviews = result.meta.hasNextPage;
    } on ApiException {
      // La liste déjà chargée reste affichée.
    } finally {
      _loadingMoreReviews = false;
      notifyListeners();
    }
  }

  /// Propage l'[ApiException] (notamment 409 ALREADY_REVIEWED) à l'appelant
  /// pour un affichage contextuel, sans jamais planter l'écran.
  Future<void> submitReview({required int rating, required String comment}) async {
    _submittingReview = true;
    notifyListeners();
    try {
      final review = await _service.postReview(_restaurantId, rating: rating, comment: comment);
      _reviews.insert(0, review);
      _reviewsState = ViewState.success(_reviews);
    } finally {
      _submittingReview = false;
      notifyListeners();
    }
  }
}
