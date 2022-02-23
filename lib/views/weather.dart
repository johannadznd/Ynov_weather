import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/models/forecast_weather.dart' as forecast;
import 'package:ynov_weather/models/meteo.dart';
import 'package:ynov_weather/services/forecast_weather_service.dart'
    as forecast_service;
import 'package:ynov_weather/services/weather_service.dart';
import 'package:ynov_weather/widget/nav_bar.dart';
import 'package:ynov_weather/widget/form_widget.dart';
import 'package:ynov_weather/models/weather.dart';

class WeatherPage extends StatefulWidget {
  final City? city;
  const WeatherPage({Key? key, this.city}) : super(key: key);
  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;

  @override
  void initState() {
    super.initState();
    name = widget.city?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: Center(child: Text(name)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/ciel_bleu.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Meteo>(
          future: getWeather(name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Chargement en cours ..."));
            } else if (snapshot.connectionState == ConnectionState.done) {
              var icon = 'http://openweathermap.org/img/wn/' +
                  snapshot.data!.weather!.first.icon.toString() +
                  "@2x.png";

              print(snapshot.data!.wind!.speed!*3.6);
              return Column(children: [
                Card(
                    margin: const EdgeInsets.all(20),
                    color: Colors.blue,
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                Text('Mardi',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const Text('23 février 2022',
                                    style: TextStyle(color: Colors.white)),
                                const Text('14:30',
                                    style: TextStyle(color: Colors.white)),
                                Container(
                                  margin: const EdgeInsets.all(2),
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Image(
                                          image: NetworkImage(icon),
                                        ),
                                        Text(
                                            snapshot.data!.weather!.first.main
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                    snapshot.data!.main!.temp!.toStringAsFixed(0) + '°C',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                Text(
                                    'Humidité : ' +
                                        snapshot.data!.main!.humidity
                                            .toString() +
                                        '%',
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    'Vent : ' +(snapshot.data!.wind!.speed!*3.6).toStringAsFixed(0) +
                                        'km/h',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ))),
              ]);
            } else {
              return const Text("Une Erreur est survenue");
            }
          },
        ),
      ),
    );
  }
}
