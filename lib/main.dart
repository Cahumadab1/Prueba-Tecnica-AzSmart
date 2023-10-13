import 'package:clima/pages/forecast.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';


void main(){
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'WeatherNow',
      initialRoute: 'home',

      routes: {

        'home':( _ ) =>  Home(),
        'forecast':( _ ) => Forecast(),

   
      },

      debugShowCheckedModeBanner: false,
    );
  }
}
