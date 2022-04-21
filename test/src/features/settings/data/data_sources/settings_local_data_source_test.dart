import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exomind/src/core/styles/themes.dart';
import 'package:exomind/src/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late SettingsLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        SettingsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastThemeMode', () {
    test(
      'should return ThemeMode from SharedPreferences when they are in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn("dark");
        // act
        final result = await dataSource.getLastThemeMode();
        // assert
        verify(mockSharedPreferences.getString(CACHED_THEME_MODE));
        expect(result, equals(themesModeMap["dark"]));
      },
    );

    test(
      'should return ThemeMode.system when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final result = await dataSource.getLastThemeMode();
        // assert
        expect(result, equals(ThemeMode.system));
      },
    );
  });

  group('cacheThemeMode', () {
    const tThemeMode = ThemeMode.dark;
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        dataSource.cacheThemeMode(tThemeMode);
        // assert
        verify(mockSharedPreferences.setString(
            CACHED_THEME_MODE, tThemeMode.toString().split('.')[1]));
      },
    );
  });
}
