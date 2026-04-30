import 'package:flutter/material.dart';
import '../models/question.dart';

class SettingsController with ChangeNotifier {
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;
  SettingsController._internal();

  ThemeMode _themeMode = ThemeMode.system;
  Difficulty _defaultDifficulty = Difficulty.medium;
  bool _notificationsEnabled = true;
  Language _language = Language.english;

  ThemeMode get themeMode => _themeMode;
  Difficulty get defaultDifficulty => _defaultDifficulty;
  bool get notificationsEnabled => _notificationsEnabled;
  Language get language => _language;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Alias for convenience
  Difficulty get difficulty => _defaultDifficulty;

  void setDifficulty(Difficulty difficulty) {
    _defaultDifficulty = difficulty;
    notifyListeners();
  }

  void setLanguage(Language lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
}
