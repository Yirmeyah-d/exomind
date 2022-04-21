import 'package:flutter/material.dart';
import 'package:exomind/src/core/use_cases/use_cases.dart';
import 'package:exomind/src/features/settings/domain/repositories/settings_repository.dart';

class LoadThemeMode {
  final SettingsRepository repository;

  LoadThemeMode(this.repository);

  Future<ThemeMode> call(NoParams params) async {
    return await repository.loadThemeMode();
  }
}
