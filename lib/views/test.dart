import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class TestPage extends StatefulWidget {
  final City? city;
  const TestPage({Key? key, this.city}) : super(key: key);
  @override
  State<TestPage> createState() => _TestState();
}

class _TestState extends State<TestPage> {
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
        appBar: AppBar(title: const Text('Create A Parking Slot')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<forecast.ForecastWeather>(
                  future: forecast_service.getForecastWeather(name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text("Chargement en cours ... "));
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                           itemCount: snapshot.data!.list!.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: Text(snapshot.data!.list![i].main!.temp!
                                      .toStringAsFixed(0) +
                                  '°C'),
                            );
                          });
                    } else {
                      return const Text("Une erreur est survenue");
                    }
                  }),
            ],
          ),
        ));
  }
}
