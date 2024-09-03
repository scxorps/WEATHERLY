// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherly/bloc/weather_bloc_bloc.dart';
import 'package:weatherly/screens/homescreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snap){
            if(snap.hasData){
              return BlocProvider<WeatherBlocBloc>(
                create: (context) => WeatherBlocBloc()..add(
                  FetchWeather(snap.data as Position)
                  ),
                child: const Homescreen(),
              );
          }else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),
              ),
            );
          }
        }
      )
    );
  }
}

Future <Position> _determinePosition() async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }


  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
