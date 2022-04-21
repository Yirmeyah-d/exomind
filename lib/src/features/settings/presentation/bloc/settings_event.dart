part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class ThemeModeChangedEvent extends SettingsEvent {
  final ThemeMode themeMode;
  const ThemeModeChangedEvent({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class SettingsLoaded extends SettingsEvent {
  const SettingsLoaded();

  @override
  List<Object> get props => [];
}
