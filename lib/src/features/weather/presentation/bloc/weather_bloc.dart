import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:exomind/src/core/utils/failure_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/current_weather_data.dart';
import '../../domain/use_cases/get_current_weather_data.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherData getCurrentWeatherData;

  Timer? percentTimer;
  int percent = 0;

  Timer? messageTimer;
  int loadingMessageNumber = 0;
  List<String> loadingMessages = [
    'Nous téléchargeons les données…',
    'C’est presque fini…',
    'Plus que quelques secondes avant d’avoir le résultat…',
  ];

  Timer? callApiTimer;
  int cityNumber = 0;
  List<String> cities = [
    'Rennes',
    'Paris',
    'Nantes',
    'Bordeaux',
    'Lyon',
  ];

  List<CurrentWeatherData> currentWeatherDataList = [];

  WeatherBloc({
    required this.getCurrentWeatherData,
  }) : super(WeatherInitial()) {
    on<GetCurrentWeather>(_onGetCurrentWeather);
    on<TimerTicked>(_onTimerTicked);
    on<TimerEnded>(_onTimerEnded);
  }

  @override
  Future<void> close() async {
    percentTimer?.cancel();
    messageTimer?.cancel();
    callApiTimer?.cancel();
    //cancel streams
    super.close();
  }

  void _eitherLoadedOrErrorState(
    Either<Failure, CurrentWeatherData> failureOrCurrentWeatherData,
    Emitter<WeatherState> emit,
  ) {
    failureOrCurrentWeatherData.fold(
      (failure) => emit(
        WeatherError(
          message: failure.mapFailureToMessage,
        ),
      ),
      (currentWeather) {
        currentWeatherDataList.add(currentWeather);
      },
    );
  }

  Future<void> _onTimerTicked(
    TimerTicked event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading(
      percent: percent,
      loadingMessage: loadingMessages[loadingMessageNumber],
    ));
  }

  Future<void> _onTimerEnded(
    TimerEnded event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoaded(
      currentWeatherDataList: currentWeatherDataList,
    ));
  }

  Future<void> _onGetCurrentWeather(
    GetCurrentWeather event,
    Emitter<WeatherState> emit,
  ) async {
    percent = 0;
    cityNumber = 0;
    loadingMessageNumber = 0;
    currentWeatherDataList = [];

    if (!(percentTimer?.isActive ?? false)) {
      percentTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        percent += 1;
        add(TimerTicked(
          percent: percent,
          loadingMessage: loadingMessages[loadingMessageNumber],
        ));
        if (percent >= 100) {
          percentTimer?.cancel();
          messageTimer?.cancel();
          add(TimerEnded(
            currentWeatherDataList: currentWeatherDataList,
          ));
        }
      });
    }

    if (!(messageTimer?.isActive ?? false)) {
      messageTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
        loadingMessageNumber += 1;

        add(TimerTicked(
          percent: percent,
          loadingMessage: loadingMessages[loadingMessageNumber],
        ));
        if (loadingMessageNumber > 2) {
          loadingMessageNumber = 0;
        }
      });
    }

    if (cityNumber < 4) {
      final failureOrCurrentWeatherData =
          await getCurrentWeatherData(Params(city: cities[cityNumber]));
      _eitherLoadedOrErrorState(failureOrCurrentWeatherData, emit);
    }

    if (!(callApiTimer?.isActive ?? false)) {
      callApiTimer =
          Timer.periodic(const Duration(milliseconds: 10000), (_) async {
        cityNumber += 1;
        if (cityNumber >= 4) {
          callApiTimer?.cancel();
        }
        final failureOrCurrentWeatherData =
            await getCurrentWeatherData(Params(city: cities[cityNumber]));

        _eitherLoadedOrErrorState(failureOrCurrentWeatherData, emit);
      });
    }
  }
}
