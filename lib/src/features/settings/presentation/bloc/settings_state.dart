part of 'settings_bloc.dart';

@immutable
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  const SettingsState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
