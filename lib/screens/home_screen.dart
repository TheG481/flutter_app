import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/weather_bloc_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String getWeatherIconPath(int code) {
    switch (code) {
      case(>= 200 && < 300) : {
        return 'assets/thunder.png';
      }
      case(>= 300 && < 500) : {
        return 'assets/rainy.png';
      }
      case(>= 500 && < 600) : {
        return 'assets/heavyrain.png';
      }
      case(>= 600 && < 700) : {
        return 'assets/snowy.png';
      }
      case(>= 700 && < 800) : {
        return 'assets/misty.png';
      }
      case(800) : {
        return 'assets/sunny.png';
      }
      case(> 800 && <= 802) : {
        return 'assets/cloudysun.png';
      }
      case(>= 803) : {
        return 'assets/cloudy.png';
      }
      default:
      return 'assets/';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 *  kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF673AB7),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 600,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFAB40),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              FutureBuilder(
                future: _determinePosition(),
                builder: (context, snap) {
                  if(snap.hasData) {
                    return BlocProvider<WeatherBlocBloc>(
                      create: (context) => WeatherBlocBloc()..add(FetchWeather(
                        snap.data as Position),
                      ),
                      child: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                        builder: (context, state) {
                          if(state is WeatherBlocSuccess) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${state.weather.areaName}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Good Morning',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        Image.asset(getWeatherIconPath(state.weather.weatherConditionCode!)),
                                        Text(
                                          '${state.weather.temperature!.celsius!.round()} *C',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                          state.weather.weatherMain!.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          DateFormat('EEEE dd -').add_jm().format(state.weather.date!),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/day.png",
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Sunrise",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                )
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                DateFormat().add_jm().format(state.weather.sunrise!),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/night.png",
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Sunset",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                )
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                DateFormat().add_jm().format(state.weather.sunset!),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5.0),
                                    child: Divider(
                                    color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/hot.png",
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Temp Max",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                )
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${state.weather.tempMax!.celsius!.round().toString()} *C',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/cold.png",
                                            scale: 8,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Temp Min",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                )
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${state.weather.tempMax!.celsius!.round().toString()} *C',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }
                      ),
                    );
                  } else {
                    return const Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}