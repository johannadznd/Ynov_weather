import 'package:flutter/material.dart';
import 'package:ynov_weather/models/weather.dart';
import 'package:ynov_weather/views/weather.dart';
 main()  {

  runApp(const MaterialApp(
    title: "Weather",
    home: WeatherPage(city: City(name: "Paris")),
  ));
}
