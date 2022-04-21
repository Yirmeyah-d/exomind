import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exomind/src/core/styles/themes.dart';

abstract class SettingsLocalDataSource {
  /// Gets the cached [ThemeMode] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ThemeMode> getLastThemeMode();

  /// Add in the cache the [ThemeMode]
  ///
  Future<void> cacheThemeMode(ThemeMode themeMode);
}

const CACHED_THEME_MODE = 'CACHED_THEME_MODE';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ThemeMode> getLastThemeMode() {
    final cachedThemeMode = sharedPreferences.getString(CACHED_THEME_MODE);
    return Future.value(themesModeMap[cachedThemeMode] ?? ThemeMode.system);
  }

  @override
  Future<void> cacheThemeMode(ThemeMode themeModeToCache) {
    return sharedPreferences.setString(
      CACHED_THEME_MODE,
      themeModeToCache.toString().split('.')[1],
    );
  }
}
