import 'package:flutter/material.dart';
import 'package:exomind/src/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:exomind/src/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'settings_repository_impl_test.mocks.dart';

@GenerateMocks([SettingsLocalDataSource])
void main() {
  MockSettingsLocalDataSource mockLocalDataSource =
      MockSettingsLocalDataSource();
  SettingsRepositoryImpl repositoryImpl = SettingsRepositoryImpl(
    localDataSource: mockLocalDataSource,
  );

  group('updateThemeMode', () {
    const tThemeMode = ThemeMode.dark;
    test(
      'should cache the theme locally when the call to update the theme is made',
      () async {
        // arrange
        when(mockLocalDataSource.cacheThemeMode(tThemeMode))
            .thenAnswer((_) async => null);
        // act
        await repositoryImpl.updateThemeMode(tThemeMode);
        // assert
        verify(mockLocalDataSource.cacheThemeMode(tThemeMode));
      },
    );
  });

  group('loadThemeMode', () {
    const tThemeMode = ThemeMode.dark;
    test(
      'should return the theme locally when the call to load the theme is made',
      () async {
        // arrange
        when(mockLocalDataSource.getLastThemeMode())
            .thenAnswer((_) async => tThemeMode);
        // act
        final result = await repositoryImpl.loadThemeMode();
        // assert
        verify(mockLocalDataSource.getLastThemeMode());
        expect(result, equals(tThemeMode));
      },
    );
  });
}
