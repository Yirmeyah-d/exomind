import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/current_weather_data.dart';

abstract class WeatherRepository {
  Future<Either<Failure, CurrentWeatherData>> getCurrentWeatherData(
      String city);
}
