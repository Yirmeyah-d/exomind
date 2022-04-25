import 'dart:convert';
import 'package:exomind/src/core/env/sk.dart';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/features/weather/data/data_sources/weather_remote_data_source.dart';
import 'package:exomind/src/features/weather/data/models/current_weather_data_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'weather_remote_data_source_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = WeatherRemoteDataSourceImpl(dio: mockDio);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockDio.get(any)).thenAnswer((_) async => Response(
          data: jsonDecode(fixture('current_weather_data.json')),
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ));
  }

  void setUpMockHttpClientFailure404() {
    when(mockDio.get(any)).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ));
  }

  group('fetchNextResultsPage', () {
    const city = "Mountain View";
    String baseUrl = 'https://api.openweathermap.org/data/2.5';

    final tCurrentWeatherDataModels = CurrentWeatherDataModel.fromJson(
        jsonDecode(fixture('current_weather_data.json')));
    test(
      '''should perform a GET request on a URL with
         city argument''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getCurrentWeatherData(city);
        // assert
        verify(mockDio.get('$baseUrl/weather?q=$city&lang=en&appid=$apiKey'));
      },
    );

    test(
      'should return CurrentWeatherDataModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getCurrentWeatherData(city);
        // assert
        expect(result, equals(tCurrentWeatherDataModels));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getCurrentWeatherData;
        // assert
        expect(() => call(city), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
