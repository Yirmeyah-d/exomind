import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/features/weather/data/models/current_weather_data_model.dart';

abstract class WeatherLocalDataSource {
  /// Gets the cached [CurrentWeatherDataModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<CurrentWeatherDataModel> getLastCurrentWeatherData();

  /// Add in the cache the [CurrentWeatherDataModel]
  ///
  Future<void> cacheCurrentWeatherData(
      CurrentWeatherDataModel currentWeatherDataToCache);
}

const CACHED_CURRENT_WEATHER_DATA = 'CACHED_CURRENT_WEATHER_DATA';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CurrentWeatherDataModel> getLastCurrentWeatherData() {
    final jsonString = sharedPreferences.getString(CACHED_CURRENT_WEATHER_DATA);
    if (jsonString != null) {
      return Future.value(
          CurrentWeatherDataModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCurrentWeatherData(
      CurrentWeatherDataModel currentWeatherDataToCache) {
    return sharedPreferences.setString(
      CACHED_CURRENT_WEATHER_DATA,
      jsonEncode(currentWeatherDataToCache.toJson()),
    );
  }
}
