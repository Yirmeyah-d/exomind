part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  final bool _isLoading;

  const WeatherState(this._isLoading);
  bool get isLoading => _isLoading;
}

class WeatherInitial extends WeatherState {
  const WeatherInitial() : super(false);

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  final int percent;
  final String loadingMessage;
  const WeatherLoading({required this.percent, required this.loadingMessage})
      : super(true);

  @override
  List<Object> get props => [percent, loadingMessage];
}

class WeatherLoaded extends WeatherState {
  final List<CurrentWeatherData> currentWeatherDataList;
  const WeatherLoaded({required this.currentWeatherDataList}) : super(true);

  @override
  List<Object> get props => [currentWeatherDataList];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError({required this.message}) : super(false);

  @override
  List<Object> get props => [message];
}
