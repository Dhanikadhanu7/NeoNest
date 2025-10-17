import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  bool _isDark = false;
  Locale _currentLocale = const Locale('en'); // ✅ Default to English

  bool get isDark => _isDark;
  Locale get currentLocale => _currentLocale;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  void changeLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}
