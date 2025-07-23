// weather_bloc_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weatherly/data/mydata.dart';
import 'package:weatherly/data/city_suggestions_service.dart';

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

    on<FetchWeatherByCity>((event, emit) async {
      print('🔍 Recherche météo pour la ville: ${event.cityName}');
      try {
        await _fetchWeatherByCity(event.cityName, emit);
      } catch (e) {
        print('❌ Erreur lors de la recherche de ${event.cityName}: $e');
        emit(WeatherBlocFailure());
      }
    });

    on<ResetWeatherBloc>((event, emit) {
      emit(WeatherBlocInitial());
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

  Future<void> _fetchWeatherByCity(String cityName, Emitter<WeatherBlocState> emit) async {
    print('� Recherche météo pour: "$cityName"');
    
    // D'abord vérifier si la ville existe dans notre base ou l'API
    final cityInfo = await CitySuggestionsService.findExactCity(cityName);
    
    if (cityInfo == null) {
      print('� Ville non trouvée: "$cityName"');
      emit(WeatherBlocCityNotFound(cityName));
      return;
    }
    
    print('✅ Ville trouvée: ${cityInfo.displayName}');
    
    WeatherFactory wf = WeatherFactory(API_KEY, language: Language.ENGLISH);
    try {
      print('📡 Appel à l\'API météo pour ${cityInfo.displayName}...');
      // Utiliser les coordonnées de la ville trouvée
      Weather weather = await wf.currentWeatherByLocation(
        cityInfo.lat, 
        cityInfo.lon
      );
      print('✅ Succès! Température: ${weather.temperature?.celsius?.round()}°C');
      emit(WeatherBlocSuccess(weather));
    } catch (e) {
      print('❌ Erreur lors de la récupération de la météo: $e');
      emit(WeatherBlocFailure(message: 'Impossible de récupérer les données météo pour ${cityInfo.displayName}'));
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
