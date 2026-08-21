import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notifications locales déclenchées à chaque changement de statut de
/// commande.
///
/// Fonctionne sur Android/iOS/Linux. Si l'initialisation échoue (ex:
/// environnement desktop sans service de notification disponible), le
/// service se met en mode silencieux plutôt que de bloquer le lancement de
/// l'app : [init] ne lance jamais d'exception.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _available = false;
  int _notificationId = 0;

  Future<void> init() async {
    try {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const linuxInit = LinuxInitializationSettings(defaultActionName: 'Ouvrir');
      const settings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
        linux: linuxInit,
      );
      final result = await _plugin.initialize(settings: settings);
      _available = result ?? true;
    } catch (error, stack) {
      _available = false;
      debugPrint('NotificationService.init a échoué, mode silencieux: $error\n$stack');
    }

    if (_available && (Platform.isAndroid)) {
      try {
        await _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } catch (_) {
        // Permission refusée ou indisponible : on continue sans notifier.
      }
    }
  }

  Future<void> notifyOrderStatusChange({required String title, required String body}) async {
    if (!_available) return;
    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'order_updates',
          'Suivi de commande',
          channelDescription: 'Notifications de changement de statut de commande',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        linux: LinuxNotificationDetails(),
      );
      await _plugin.show(id: _notificationId++, title: title, body: body, notificationDetails: details);
    } catch (error) {
      debugPrint('NotificationService.notifyOrderStatusChange a échoué: $error');
    }
  }
}
