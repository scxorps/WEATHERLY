part of 'weather_bloc_bloc.dart';

sealed class WeatherBlocEvent extends Equatable {
  const WeatherBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherBlocEvent {
  final Position position;

  const FetchWeather(this.position);

  @override
  List<Object> get props => [position];
}

class UpdateWeather extends WeatherBlocEvent {
  final Position position;

  const UpdateWeather(this.position);

  @override
  List<Object> get props => [position];
}

class FetchWeatherByCity extends WeatherBlocEvent {
  final String cityName;

  const FetchWeatherByCity(this.cityName);

  @override  
  List<Object> get props => [cityName];
}

class ResetWeatherBloc extends WeatherBlocEvent {
  const ResetWeatherBloc();
}
