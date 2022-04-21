part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetCurrentWeather extends WeatherEvent {
  @override
  List<Object> get props => [];
}

class TimerTicked extends WeatherEvent {
  final int percent;
  final String loadingMessage;
  const TimerTicked({required this.percent, required this.loadingMessage});

  @override
  List<Object> get props => [percent, loadingMessage];
}

class TimerEnded extends WeatherEvent {
  final List<CurrentWeatherData> currentWeatherDataList;
  const TimerEnded({required this.currentWeatherDataList});

  @override
  List<Object> get props => [currentWeatherDataList];
}
