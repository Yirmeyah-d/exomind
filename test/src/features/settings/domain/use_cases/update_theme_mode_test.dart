import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exomind/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:exomind/src/features/settings/domain/use_cases/update_theme_mode.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'update_theme_mode_test.mocks.dart';

@GenerateMocks([SettingsRepository])
void main() {
  // initialization outside of setUp
  final mockSettingsRepository = MockSettingsRepository();
  final useCase = UpdateThemeMode(mockSettingsRepository);
  const tThemeMode = ThemeMode.dark;

  test(
    'should get the theme mode from the repository',
    () async {
      //arrange
      when(mockSettingsRepository.updateThemeMode(tThemeMode))
          .thenAnswer((_) async => tThemeMode);
      // act
      await useCase(const Params(themeMode: tThemeMode));
      // assert
      verify(mockSettingsRepository.updateThemeMode(tThemeMode));
      verifyNoMoreInteractions(mockSettingsRepository);
    },
  );
}
