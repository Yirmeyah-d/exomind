import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> updateThemeMode(ThemeMode themeMode);
  Future<ThemeMode> loadThemeMode();
}
