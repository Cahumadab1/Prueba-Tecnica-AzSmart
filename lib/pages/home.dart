import 'dart:convert';

import 'package:clima/models/weather_result.dart';
import 'package:clima/pages/forecast.dart';
import 'package:clima/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clima/models/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();
  String imageUrl = '';
  String searchLocationCity = 'https://api.openweathermap.org/data/2.5/weather?lat=';
  String ApiSearch = '&lang=es&appid=95f83bb5234a7c4f99bab010c709a1d6';

  Future<weatherResult> getWeatherData() async {
    final service = LocationService();
    final locationData = await service.getLocation();

    if (locationData == null) {
      throw Exception("Location data is null");
    }

    var searchResult = await http.get(Uri.parse(
        '$searchLocationCity${locationData.latitude}&lon=${locationData.longitude}$ApiSearch'));
    return weatherResult.fromJson(jsonDecode(searchResult.body));
  }

  Shader get linearGradient => const LinearGradient(
        colors: <Color>[Color.fromARGB(255, 165, 207, 250), Color(0xff9AC6F3)],
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: getWeatherData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No Data',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          );
        } else {
          final data = snapshot.data as weatherResult;
          var currentDate =
              DateTime.fromMillisecondsSinceEpoch((data.dt ?? 0) * 1000);

          return Scaffold(
            appBar: AppBar(
              title: Text('Clima en ${data.name.toString()}'),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color.fromARGB(255, 158, 204, 236)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoy en ${data.name.toString()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        'Actualizado el ${currentDate.toString()}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.blue],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.7),
                              offset: const Offset(0, 10),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 70,
                              left: 100,
                              child: Image.network(
                                'https://openweathermap.org/img/wn/${data.weather![0].icon}@4x.png',
                                width: 150,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 20,
                              child: Text(
                                data.weather![0].main.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '${data.main!.temp.toString()}F',
                                      style: TextStyle(
                                        fontSize: 70,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..shader = linearGradient,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'o',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()..shader = linearGradient,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    bottom: 137,
                    width: size.width,
                    height: 80,
              
                    child: ElevatedButton(
                      
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Forecast()), 
                        );

                      },

                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: const TextStyle(fontSize: 18),
                        elevation: 10,
                      ),
                      
                      
                      child: const Text('Pronostico'),
                      
                    ),
                  ),
                  Positioned(
                    bottom: 275,
                    width: size.width,
                    height: 80,
                    
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()), 
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: const TextStyle(fontSize: 18),
                        elevation: 10,
                        
                      ),
                      child: const Text('Actualizar app'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
