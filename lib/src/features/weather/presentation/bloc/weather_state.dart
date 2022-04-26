part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  final int percent;
  final String loadingMessage;
  const WeatherLoading({required this.percent, required this.loadingMessage});

  @override
  List<Object> get props => [percent, loadingMessage];
}

class WeatherLoaded extends WeatherState {
  final List<CurrentWeatherData> currentWeatherDataList;
  const WeatherLoaded({required this.currentWeatherDataList});

  @override
  List<Object> get props => [currentWeatherDataList];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError({required this.message});

  @override
  List<Object> get props => [message];
}
