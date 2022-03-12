import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/models/forecast_weather.dart' as forecast;
import 'package:ynov_weather/models/meteo.dart';
import 'package:ynov_weather/services/forecast_weather_service.dart'
    as forecast_service;
import 'package:ynov_weather/services/weather_service.dart';
import 'package:ynov_weather/widget/forecast_weather_widget.dart';
import 'package:ynov_weather/widget/nav_bar.dart';
import 'package:ynov_weather/widget/form_widget.dart';
import 'package:ynov_weather/models/weather.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ynov_weather/widget/weather_day_widget.dart';

class WeatherPage extends StatefulWidget {
  final City? city;
  const WeatherPage({Key? key, this.city}) : super(key: key);
  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
  late SharedPreferences prefs;

  String? value;

  retrieveStringValue() async {
    prefs = await SharedPreferences.getInstance();
    value = prefs.getString("name");
  }

  final _formKey = GlobalKey<FormState>();

  late String name;

  @override
  void initState() {
    super.initState();
    retrieveStringValue();
    print(value);
    name = widget.city?.name ?? value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meteo>(
        future: getWeather(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                drawer: const NavBar(),
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text('Méteo', style: TextStyle(fontSize: 25)),
                  backgroundColor: Colors.transparent,
                ),
                body: const Text("Chargement en cours ..."));
          } else if (snapshot.connectionState == ConnectionState.done) {
            var icon = 'http://openweathermap.org/img/wn/' +
                snapshot.data!.weather!.first.icon.toString() +
                "@2x.png";
            var timestamp1 = snapshot.data!.dt;
            final DateTime date1 =
                DateTime.fromMillisecondsSinceEpoch(timestamp1! * 1000);
            final dayOfWeek = Jiffy(date1).format('EEEE');
            final day = Jiffy(date1).format('d MMMM yyyy');
            final hour = Jiffy(date1).format('h:mm');
            final date = dayOfWeek + " " + day + " " + hour;

            var fond = "";

            if (snapshot.data!.weather!.first.main.toString() ==
                "Thunderstorm") {
              fond = "asset/images/Thunderstorm.jpg";
            } else if (snapshot.data!.weather!.first.main.toString() ==
                "Drizzle") {
              fond = "asset/images/Drizzle.jpg";
            } else if (snapshot.data!.weather!.first.main.toString() ==
                "Rain") {
              fond = "asset/images/Rain.jpg";
            } else if (snapshot.data!.weather!.first.main.toString() ==
                "Snow") {
              fond = "asset/images/Snow.jpg";
            } else if (snapshot.data!.weather!.first.main.toString() ==
                "Clouds") {
              fond = "asset/images/Clouds.jpg";
            } else {
              fond = "asset/images/ciel_bleu.jpg";
            }

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(fond),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                  drawer: NavBar(),
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: const Text('Méteo',
                        style: TextStyle(fontSize: 25)),
                    backgroundColor: Colors.transparent,
                  ),
                  body: Column(
                    children: [
                      WeatherDayWidget(
                          name: name,
                          context: context,
                          snapshot: snapshot,
                          date: date,
                          icon: icon),
                      FutureBuilder<forecast.ForecastWeather>(
                          future: forecast_service.getForecastWeather(name),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: Text("Chargement en cours ... "));
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Flexible(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.list!.length,
                                    itemBuilder: (context, i) {
                                      var icon =
                                          'http://openweathermap.org/img/wn/' +
                                              snapshot.data!.list![i].weather!
                                                  .first.icon
                                                  .toString() +
                                              "@2x.png";
                                      var timestamp1 =
                                          snapshot.data!.list![i].dt;
                                      final DateTime date1 =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              timestamp1! * 1000);
                                      final dayOfWeek =
                                          Jiffy(date1).format('EEEE');
                                      final date =
                                          Jiffy(date1).format('d MMMM yyyy');
                                      return ForecastWeatherWidget(
                                          i: i,
                                          snapshot: snapshot,
                                          date: date,
                                          icon: icon);
                                    }),
                              );
                            } else {
                              return const Text("Une erreur est survenue");
                            }
                          }),
                    ],
                  )),
            );
          } else {
            return const Scaffold(body: Text("Une Erreur est survenue"));
          }
        });
  }
}
