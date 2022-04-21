import 'package:dio/dio.dart';
import 'package:exomind/src/core/env/sk.dart';
import 'package:exomind/src/core/error/exceptions.dart';
import 'package:exomind/src/features/weather/data/models/current_weather_data_model.dart';

abstract class WeatherRemoteDataSource {
  /// Calls the $baseUrl/weather?q=$city&lang=en&$apiKey endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CurrentWeatherDataModel> getCurrentWeatherData(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final Dio dio;

  WeatherRemoteDataSourceImpl({required this.dio});

  @override
  Future<CurrentWeatherDataModel> getCurrentWeatherData(String city) async =>
      _getCurrentWeatherDataFromUrl(
          '$baseUrl/weather?q=$city&lang=en&appid=$apiKey');

  Future<CurrentWeatherDataModel> _getCurrentWeatherDataFromUrl(
      String url) async {
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return CurrentWeatherDataModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }
}
