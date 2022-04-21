import 'package:bloc_test/bloc_test.dart';
import 'package:exomind/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:exomind/src/core/styles/themes.dart';
import 'package:exomind/src/core/use_cases/use_cases.dart';
import 'package:exomind/src/features/settings/domain/use_cases/load_theme_mode.dart';
import 'package:exomind/src/features/settings/domain/use_cases/update_theme_mode.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'settings_bloc_test.mocks.dart';

@GenerateMocks([
  UpdateThemeMode,
  LoadThemeMode,
])
void main() {
  late SettingsBloc settingsBloc;
  late MockUpdateThemeMode mockUpdateThemeMode;
  late MockLoadThemeMode mockLoadThemeMode;

  setUp(() {
    mockUpdateThemeMode = MockUpdateThemeMode();
    mockLoadThemeMode = MockLoadThemeMode();
    settingsBloc = SettingsBloc(
      updateThemeMode: mockUpdateThemeMode,
      loadThemeMode: mockLoadThemeMode,
    );
  });

  test('initialState should be SettingsState', () {
    //assert
    expect(settingsBloc.state,
        equals(SettingsState(themeMode: themesModeMap["dark"]!)));
  });

  group('ThemeModeChangedEvent', () {
    const tThemeMode = ThemeMode.dark;

    blocTest<SettingsBloc, SettingsState>(
      'updateThemeMode use case should get call',
      build: () {
        when(mockUpdateThemeMode(any)).thenAnswer((_) async => tThemeMode);
        return settingsBloc;
      },
      act: (bloc) async {
        bloc.add(const ThemeModeChangedEvent(themeMode: tThemeMode));
        await untilCalled(mockUpdateThemeMode(any));
      },
      verify: (_) {
        verify(mockUpdateThemeMode(const Params(themeMode: tThemeMode)));
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emit [SettingsState] ThemeModeChangedEvent is triggered',
      build: () {
        when(mockUpdateThemeMode(any)).thenAnswer((_) async => tThemeMode);
        return settingsBloc;
      },
      act: (bloc) =>
          bloc.add(const ThemeModeChangedEvent(themeMode: tThemeMode)),
      expect: () => [
        const SettingsState(themeMode: tThemeMode),
      ],
    );
  });

  group('SettingsLoaded', () {
    const tThemeMode = ThemeMode.dark;

    blocTest<SettingsBloc, SettingsState>(
      'loadThemeMode use case should get call',
      build: () {
        when(mockLoadThemeMode(any)).thenAnswer((_) async => tThemeMode);
        return settingsBloc;
      },
      act: (bloc) async {
        bloc.add(const SettingsLoaded());
        await untilCalled(mockLoadThemeMode(any));
      },
      verify: (_) {
        verify(mockLoadThemeMode(NoParams()));
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'emit [SettingsState] SettingsLoaded is triggered',
      build: () {
        when(mockLoadThemeMode(any)).thenAnswer((_) async => tThemeMode);
        return settingsBloc;
      },
      act: (bloc) => bloc.add(const SettingsLoaded()),
      expect: () => [
        const SettingsState(themeMode: tThemeMode),
      ],
    );
  });
}
