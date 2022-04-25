import 'dart:convert';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_local_data_source.dart';
import 'package:exomind/src/features/weather/data/models/clouds_model.dart';
import 'package:exomind/src/features/weather/data/models/coord_model.dart';
import 'package:exomind/src/features/weather/data/models/current_weather_data_model.dart';
import 'package:exomind/src/features/weather/data/models/main_weather_model.dart';
import 'package:exomind/src/features/weather/data/models/sys_model.dart';
import 'package:exomind/src/features/weather/data/models/weather_model.dart';
import 'package:exomind/src/features/weather/data/models/wind_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late WeatherLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource =
        WeatherLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastCurrentWeatherData', () {
    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getStringList(any)).thenReturn(null);
        // act
        final call = dataSource.getLastCurrentWeatherData;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheCurrentWeatherData', () {
    final tCurrentWeatherDataModels = [
      const CurrentWeatherDataModel(
        coord: CoordModel(lon: -1.6667, lat: 48.1667),
        weather: [
          WeatherModel(
              id: 800, main: "Clear", description: "clear sky", icon: "01n")
        ],
        base: "stations",
        main: MainWeatherModel(
            temp: 285.17,
            feelsLike: 284.05,
            tempMin: 282.57,
            tempMax: 285.17,
            pressure: 1015,
            humidity: 62),
        visibility: 10000,
        wind: WindModel(speed: 4.12, deg: 20),
        clouds: CloudsModel(all: 0),
        dt: 1650918553,
        sys: SysModel(
            type: 1,
            id: 6965,
            country: "FR",
            sunrise: 1650862712,
            sunset: 1650913827),
        timezone: 7200,
        id: 2983989,
        name: "Arrondissement de Rennes",
        cod: 200,
      ),
      const CurrentWeatherDataModel(
        coord: CoordModel(lon: -1.6667, lat: 48.1667),
        weather: [
          WeatherModel(
              id: 800, main: "Clear", description: "clear sky", icon: "01n")
        ],
        base: "stations",
        main: MainWeatherModel(
            temp: 285.17,
            feelsLike: 284.05,
            tempMin: 282.57,
            tempMax: 285.17,
            pressure: 1015,
            humidity: 62),
        visibility: 10000,
        wind: WindModel(speed: 7.20, deg: 17),
        clouds: CloudsModel(all: 0),
        dt: 1650918553,
        sys: SysModel(
            type: 1,
            id: 3923,
            country: "FR",
            sunrise: 1650862712,
            sunset: 1650913827),
        timezone: 7200,
        id: 2983989,
        name: "Arrondissement de Paris",
        cod: 200,
      ),
    ];
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setStringList(any, any))
            .thenAnswer((_) async => true);
        // act
        dataSource.cacheCurrentWeatherData(tCurrentWeatherDataModels);
        // assert
        final expectedJsonStringList = tCurrentWeatherDataModels
            .map((resultsPage) => jsonEncode(resultsPage.toJson()))
            .toList();
        verify(mockSharedPreferences.setStringList(
            CACHED_CURRENT_WEATHER_DATA, expectedJsonStringList));
      },
    );
  });
}
