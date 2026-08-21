import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Détection de la perte de connexion réseau, pour afficher la bannière
/// hors ligne et adapter le comportement des providers de données
/// (repli sur cache).
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  Future<void> _init() async {
    try {
      final initial = await _connectivity.checkConnectivity();
      _apply(initial);
    } catch (_) {
      // Environnement sans plugin réseau disponible (rare) : suppose en ligne.
    }
    _subscription = _connectivity.onConnectivityChanged.listen(_apply);
  }

  void _apply(List<ConnectivityResult> results) {
    final offline = results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (offline == _isOffline) return;
    _isOffline = offline;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
