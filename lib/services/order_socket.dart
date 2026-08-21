import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/config/app_config.dart';
import '../core/constants/app_constants.dart';
import '../core/storage/secure_storage.dart';

enum SocketConnectionStatus { connecting, connected, disconnected }

/// Client WebSocket pour le suivi de commande en temps réel.
///
/// Robustesse :
/// - avant chaque (re)connexion, [_ensureFreshToken] est appelé pour
///   garantir un access token valide (le token embarqué dans l'URL WS
///   expire comme n'importe quel access token) ;
/// - une fermeture avec le code 4001 (token invalide) déclenche un
///   rafraîchissement puis une reconnexion ;
/// - toute autre coupure déclenche une reconnexion avec un backoff
///   croissant borné ;
/// - [statusStream] permet à l'appelant ([OrderTrackingProvider]) de
///   basculer sur un repli en polling REST quand la connexion est perdue.
class OrderSocket {
  OrderSocket({required SecureStorage secureStorage, required Future<void> Function() ensureFreshToken})
      : _secureStorage = secureStorage,
        _ensureFreshToken = ensureFreshToken;

  final SecureStorage _secureStorage;
  final Future<void> Function() _ensureFreshToken;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;
  bool _disposed = false;
  int _retryCount = 0;

  final _statusController = StreamController<SocketConnectionStatus>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<SocketConnectionStatus> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect() async {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _statusController.add(SocketConnectionStatus.connecting);

    try {
      await _ensureFreshToken();
      final token = await _secureStorage.readAccessToken();
      if (token == null || token.isEmpty) {
        _scheduleReconnect();
        return;
      }

      final channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl(token)));
      await channel.ready;
      if (_disposed) {
        await channel.sink.close();
        return;
      }

      _channel = channel;
      _retryCount = 0;
      _statusController.add(SocketConnectionStatus.connected);
      _subscription = channel.stream.listen(_onData, onDone: _onDone, onError: (_) => _onDone(), cancelOnError: true);
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    if (raw is! String) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) _messageController.add(decoded);
    } on FormatException {
      // Message non-JSON ignoré.
    }
  }

  void _onDone() {
    if (_disposed) return;
    _statusController.add(SocketConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _retryCount++;
    final multiplier = _retryCount.clamp(1, 5);
    _reconnectTimer = Timer(AppDurations.wsReconnectDelay * multiplier, connect);
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;
    if (!_disposed) _statusController.add(SocketConnectionStatus.disconnected);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _statusController.close();
    _messageController.close();
  }
}
