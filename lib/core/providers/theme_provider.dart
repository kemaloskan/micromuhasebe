import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  ThemeProvider() {
    // Load theme immediately without async
    _loadThemeMode();
  }
  
  void _loadThemeMode() {
    // Load theme synchronously
    SharedPreferences.getInstance().then((prefs) {
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      if (themeIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[themeIndex];
        notifyListeners();
      }
    });
  }
  
  void toggleTheme() {
    print('toggleTheme çağrıldı, mevcut tema: $_themeMode');
    if (_themeMode == ThemeMode.light || _themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    print('Yeni tema: $_themeMode');
    _saveThemeMode();
    notifyListeners();
  }
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }
  
  void _saveThemeMode() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_themeKey, _themeMode.index);
    });
  }
} 