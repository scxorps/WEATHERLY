// weather_bloc_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weatherly/data/mydata.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  late StreamSubscription<Position> _positionSubscription;

  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>((event, emit) async {
      try {
        await _fetchWeather(event.position, emit);
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });

    on<UpdateWeather>((event, emit) async {
      try {
        await _fetchWeather(event.position, emit);
      } catch (e) {
        emit(WeatherBlocFailure());
      }
    });
  }

  Future<void> _fetchWeather(Position position, Emitter<WeatherBlocState> emit) async {
    WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
    try {
      Weather weather = await wf.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      emit(WeatherBlocSuccess(weather));
    } catch (e) {
      emit(WeatherBlocFailure());
    }
  }

  @override
  Future<void> close() {
    _positionSubscription.cancel();
    return super.close();
  }

  void startListeningToPositionUpdates() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((position) {
      add(UpdateWeather(position));
    });
  }
}
