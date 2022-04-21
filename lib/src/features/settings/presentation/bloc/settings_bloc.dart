import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exomind/src/core/styles/themes.dart';
import 'package:exomind/src/core/use_cases/use_cases.dart';
import 'package:exomind/src/features/settings/domain/use_cases/load_theme_mode.dart';
import 'package:exomind/src/features/settings/domain/use_cases/update_theme_mode.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UpdateThemeMode updateThemeMode;
  final LoadThemeMode loadThemeMode;

  SettingsBloc({
    required this.updateThemeMode,
    required this.loadThemeMode,
  }) : super(SettingsState(themeMode: themesModeMap["dark"]!)) {
    on<ThemeModeChangedEvent>(_onThemeModeChanged);
    on<SettingsLoaded>(_onSettingsLoaded);
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChangedEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await updateThemeMode(Params(themeMode: event.themeMode));
    emit(SettingsState(themeMode: event.themeMode));
  }

  Future<void> _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    final themeMode = await loadThemeMode(NoParams());
    emit(SettingsState(themeMode: themeMode));
  }
}
