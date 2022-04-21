import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:exomind/src/features/weather/domain/entities/current_weather_data.dart';
import 'package:exomind/src/features/weather/domain/repositories/weather_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_cases.dart';

class GetCurrentWeatherData implements UseCase<CurrentWeatherData, Params> {
  final WeatherRepository repository;

  GetCurrentWeatherData(this.repository);

  @override
  Future<Either<Failure, CurrentWeatherData>> call(Params params) async {
    return await repository.getCurrentWeatherData(params.city);
  }
}

class Params extends Equatable {
  final String city;

  const Params({required this.city});

  @override
  List<Object> get props => [city];
}
