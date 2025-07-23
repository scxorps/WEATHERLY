part of 'weather_bloc_bloc.dart';

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

class WeatherBlocInitial extends WeatherBlocState {}

class WeatherBlocSuccess extends WeatherBlocState {
  final Weather weather;

  const WeatherBlocSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherBlocFailure extends WeatherBlocState {
  final String message;

  const WeatherBlocFailure({this.message = 'Une erreur est survenue'});

  @override
  List<Object> get props => [message];
}

class WeatherBlocCityNotFound extends WeatherBlocState {
  final String cityName;

  const WeatherBlocCityNotFound(this.cityName);

  @override
  List<Object> get props => [cityName];
}
