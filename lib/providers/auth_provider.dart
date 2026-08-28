import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/user.dart';
import '../models/view_state.dart';
import '../services/auth_service.dart';

/// État d'authentification global de l'application.
///
/// Source de vérité unique pour la session : les autres providers
/// authentifiés (panier, commandes, favoris...) l'observent via
/// `ChangeNotifierProxyProvider` pour savoir si l'utilisateur est connecté,
/// sans jamais toucher au stockage sécurisé eux-mêmes.
class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthService authService, required DioClient dioClient, required SecureStorage secureStorage})
      : _authService = authService,
        _dioClient = dioClient,
        _secureStorage = secureStorage {
    _dioClient.authInterceptor.onSessionExpired = _handleSessionExpired;
  }

  final AuthService _authService;
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  ViewState<User> _state = const ViewState.initial();
  ViewState<User> get state => _state;

  bool get isAuthenticated => _state.isSuccess && _state.data != null;
  User? get currentUser => _state.data;

  /// Restaure la session au démarrage (appelé par le splash screen).
  /// Retourne `true` si une session valide a été trouvée.
  Future<bool> restoreSession() async {
    final accessToken = await _secureStorage.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      _state = const ViewState.initial();
      notifyListeners();
      return false;
    }
    try {
      final user = await _authService.me();
      _state = ViewState.success(user);
      notifyListeners();
      return true;
    } on ApiException {
      await _secureStorage.clear();
      _state = const ViewState.initial();
      notifyListeners();
      return false;
    }
  }

  Future<void> login({required String email, required String password}) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final result = await _authService.login(email: email, password: password);
      await _secureStorage.saveTokens(accessToken: result.accessToken, refreshToken: result.refreshToken);
      _state = ViewState.success(result.user);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message, data: null, errorCode: e.code);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> register({required String name, required String email, required String password}) async {
    _state = const ViewState.loading();
    notifyListeners();
    try {
      final result = await _authService.register(name: name, email: email, password: password);
      await _secureStorage.saveTokens(accessToken: result.accessToken, refreshToken: result.refreshToken);
      _state = ViewState.success(result.user);
    } on ApiException catch (e) {
      _state = ViewState.error(e.message, data: null, errorCode: e.code);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? phone}) async {
    final updated = await _authService.updateMe(name: name, phone: phone);
    _state = ViewState.success(updated);
    notifyListeners();
  }

  Future<void> uploadAvatar({required List<int> bytes, required String filename, required String mimeSubtype}) async {
    final updated = await _authService.uploadAvatar(bytes: bytes, filename: filename, mimeSubtype: mimeSubtype);
    _state = ViewState.success(updated);
    notifyListeners();
  }

  Future<void> logout() async {
    final refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _authService.logout(refreshToken);
      } on ApiException {
        // La déconnexion locale doit réussir même si l'appel réseau échoue.
      }
    }
    await _secureStorage.clear();
    _state = const ViewState.initial();
    notifyListeners();
  }

  /// Garantit un access token frais avant une opération sensible au temps
  /// (ex: (re)connexion WebSocket). S'appuie sur l'intercepteur de
  /// rafraîchissement transparent en déclenchant un appel authentifié léger.
  Future<void> ensureFreshToken() async {
    if (!isAuthenticated) return;
    try {
      await _authService.me();
    } on ApiException {
      // Si le token est définitivement invalide, onSessionExpired prendra le relais.
    }
  }

  void _handleSessionExpired() {
    if (!isAuthenticated) return;
    _secureStorage.clear();
    _state = const ViewState.initial();
    notifyListeners();
  }
}
