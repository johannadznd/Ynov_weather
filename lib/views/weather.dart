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
import 'package:jiffy/jiffy.dart';

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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder<Meteo>(
                future: getWeather(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Chargement en cours ..."));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    var icon = 'http://openweathermap.org/img/wn/' +
                        snapshot.data!.weather!.first.icon.toString() +
                        "@2x.png";
                    var timestamp1 = snapshot.data!.dt;
                    final DateTime date1 =
                        DateTime.fromMillisecondsSinceEpoch(timestamp1! * 1000);
                    final dayOfWeek = Jiffy(date1).format('EEEE');
                    final date = Jiffy(date1).format('d MMMM yyyy');
                    final hour = Jiffy(date1).format('h:mm');
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          return Column(children: [
                            Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.all(20),
                                color: Colors.blueGrey,
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(dayOfWeek.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white)),
                                            Text(date,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Text(hour,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Card(
                                              color: Colors.blueGrey,
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              margin: const EdgeInsets.all(2),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      Image(
                                                        image:
                                                            NetworkImage(icon),
                                                      ),
                                                      Text(
                                                          snapshot
                                                              .data!
                                                              .weather!
                                                              .first
                                                              .main
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                    ],
                                                  ),
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
                                                snapshot.data!.main!.temp!
                                                        .toStringAsFixed(0) +
                                                    '°C',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25)),
                                            Text(
                                                'Humidité : ' +
                                                    snapshot
                                                        .data!.main!.humidity
                                                        .toString() +
                                                    '%',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Text(
                                                'Vent : ' +
                                                    (snapshot.data!.wind!
                                                                .speed! *
                                                            3.6)
                                                        .toStringAsFixed(0) +
                                                    'km/h',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        )
                                      ],
                                    ))),
                          ]);
                        });
                  } else {
                    return const Text("Une Erreur est survenue");
                  }
                },
              ),
              SingleChildScrollView(
                  child: FutureBuilder<forecast.ForecastWeather>(
                      future: forecast_service.getForecastWeather(name),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text("Chargement en cours ..."));
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.list!.length,
                              itemBuilder: (context, i) {
                                return Card(
                                  child: Text(snapshot
                                          .data!.list![i].main!.temp!
                                          .toStringAsFixed(0) +
                                      '°C'),
                                );
                              });
                        } else {
                          return const Text("Une Erreur est survenue");
                        }
                      }))
            ],
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/images/ciel_bleu.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
