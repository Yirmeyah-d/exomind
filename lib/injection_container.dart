import 'package:dio/dio.dart';
import 'package:exomind/src/core/network/network_info.dart';
import 'package:exomind/src/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:exomind/src/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:exomind/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:exomind/src/features/settings/domain/use_cases/load_theme_mode.dart';
import 'package:exomind/src/features/settings/domain/use_cases/update_theme_mode.dart';
import 'package:exomind/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_local_data_source.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:exomind/src/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:exomind/src/features/weather/domain/repositories/weather_repository.dart';
import 'package:exomind/src/features/weather/domain/use_cases/get_current_weather_data.dart';
import 'package:exomind/src/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final serviceLocator = GetIt.instance;
Future<void> init() async {
  //! Features - Weather

  // Bloc
  serviceLocator.registerFactory(
    () => WeatherBloc(
      getCurrentWeatherData: serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => GetCurrentWeatherData(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      dio: serviceLocator(),
    ),
  );

  //! Features - Settings
  //Bloc
  serviceLocator.registerFactory(
    () => SettingsBloc(
      loadThemeMode: serviceLocator(),
      updateThemeMode: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => UpdateThemeMode(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoadThemeMode(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: serviceLocator(),
    ),
  );

  // Data Sources
  serviceLocator.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      serviceLocator(),
    ),
  );

  //! External
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
