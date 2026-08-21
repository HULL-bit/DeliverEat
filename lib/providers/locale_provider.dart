import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

/// Langue courante de l'application (FR/EN), persistée localement.
class LocaleProvider extends ChangeNotifier {
  LocaleProvider({required SharedPreferences prefs}) : _prefs = prefs {
    final stored = _prefs.getString(StorageKeys.localeCode);
    _locale = stored != null ? Locale(stored) : const Locale('fr');
  }

  final SharedPreferences _prefs;
  late Locale _locale;

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    await _prefs.setString(StorageKeys.localeCode, locale.languageCode);
  }
}
