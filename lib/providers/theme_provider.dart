import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

/// Préférence de thème clair/sombre, persistée localement.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider({required SharedPreferences prefs}) : _prefs = prefs {
    final stored = _prefs.getString(StorageKeys.themeMode);
    _mode = switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  final SharedPreferences _prefs;
  late ThemeMode _mode;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(StorageKeys.themeMode, mode.name);
  }

  Future<void> toggleDark(bool value) => setMode(value ? ThemeMode.dark : ThemeMode.light);
}
