import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/features/weather/data/models/current_weather_data_model.dart';

abstract class WeatherLocalDataSource {
  /// Gets the cached list of [CurrentWeatherDataModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<CurrentWeatherDataModel>> getLastCurrentWeatherData();

  /// Add in the cache the list of [CurrentWeatherDataModel]
  ///
  Future<void> cacheCurrentWeatherData(
      List<CurrentWeatherDataModel> currentWeatherDataToCache);
}

const CACHED_CURRENT_WEATHER_DATA = 'CACHED_CURRENT_WEATHER_DATA';

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CurrentWeatherDataModel>> getLastCurrentWeatherData() {
    final jsonCitiesCurrentWeatherData =
        sharedPreferences.getStringList(CACHED_CURRENT_WEATHER_DATA);
    if (jsonCitiesCurrentWeatherData != null) {
      return Future.value(jsonCitiesCurrentWeatherData
          .map((currentWeatherData) =>
              CurrentWeatherDataModel.fromJson(jsonDecode(currentWeatherData)))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCurrentWeatherData(
      List<CurrentWeatherDataModel> citiesCurrentWeatherDataToCache) {
    List<String> citiesCurrentWeatherDataEncoded =
        citiesCurrentWeatherDataToCache
            .map(
                (currentWeatherData) => jsonEncode(currentWeatherData.toJson()))
            .toList();

    return sharedPreferences.setStringList(
      CACHED_CURRENT_WEATHER_DATA,
      citiesCurrentWeatherDataEncoded,
    );
  }
}
