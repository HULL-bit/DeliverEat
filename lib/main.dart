import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app.dart';
import 'core/media/media_picker_service.dart';
import 'core/network/dio_client.dart';
import 'core/notifications/notification_service.dart';
import 'core/storage/secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

  final prefs = await SharedPreferences.getInstance();
  final secureStorage = SecureStorage();
  final dioClient = DioClient(secureStorage: secureStorage);
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(DeliverEatApp(
    prefs: prefs,
    secureStorage: secureStorage,
    dioClient: dioClient,
    notificationService: notificationService,
    mediaPickerService: MediaPickerService(),
  ));
}
