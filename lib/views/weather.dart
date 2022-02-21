import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/models/meteo.dart';
import 'package:ynov_weather/models/weather.dart' as wt;

import 'package:ynov_weather/services/weather_service.dart';
import 'package:ynov_weather/db/weather.dart' as db;

class WeatherPage extends StatelessWidget {
  

  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WeatherSF() ;
  }
}

class WeatherSF extends StatefulWidget {
  const WeatherSF({Key? key}) : super(key: key);

  @override
  State<WeatherSF> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherSF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Météo"),),
      body: Center(
        child : Column(
          children: [
            FutureBuilder<Meteo>(
              future: getWeather('Paris'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Chargement en cours ..."));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ListTile(
                    title: const Text('Test zef'),
                    subtitle: Text(snapshot.data!.weather!.first.icon.toString()),
                    trailing: Text(snapshot.data!.coord!.lon.toString()),
                  );
                } else {
                  return const Text("Une Erreur est survenue");
                }
              },
            )
          ],
        ),
         
      )
    );
  }
}
