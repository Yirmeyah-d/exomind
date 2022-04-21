import 'package:exomind/src/features/weather/domain/entities/main_weather.dart';

class MainWeatherModel extends MainWeather {
  const MainWeatherModel({
    required double temp,
    required double feelsLike,
    required double tempMin,
    required double tempMax,
    required int pressure,
    required int humidity,
  }) : super(
          temp: temp,
          feelsLike: feelsLike,
          tempMin: tempMin,
          tempMax: tempMax,
          pressure: pressure,
          humidity: humidity,
        );

  factory MainWeatherModel.fromJson(Map<String, dynamic> json) {
    return MainWeatherModel(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'],
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'pressure': pressure,
      'humidity': humidity,
    };
  }
}
