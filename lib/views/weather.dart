import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/models/meteo.dart';
import 'package:ynov_weather/services/weather_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes todos"),),
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
                    title: const Text('tet'),
                    subtitle: Text(snapshot.data!.coord!.lat.toString()),
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