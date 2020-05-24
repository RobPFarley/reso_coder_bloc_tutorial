import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reso_coder_bloc_tutorial/data/model/weather.dart';
import 'package:reso_coder_bloc_tutorial/data/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      yield* _handleGetWeather(event);
    } else if (event is GetDetailedWeather) {
      yield* _handleGetDetailedWeather(event);
    }
  }

  Stream<WeatherState> _handleGetWeather(GetWeather event) async* {
    yield WeatherLoading();

    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      yield WeatherLoaded(weather);
    } on NetworkError {
      yield WeatherError('Couldn\'t fetch weather, is the device online?');
    }
  }

  Stream<WeatherState> _handleGetDetailedWeather(GetDetailedWeather event) async* {
    yield WeatherLoading();

    try {
      final weather = await weatherRepository.fetchDetailedWeather(event.cityName);
      yield WeatherLoaded(weather);
    } on NetworkError {
      yield WeatherError('Couldn\'t fetch weather, is the device online?');
    }
  }
}
