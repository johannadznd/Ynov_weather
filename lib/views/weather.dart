import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/models/forecast_weather.dart' as test2;
import 'package:ynov_weather/models/meteo.dart';
import 'package:ynov_weather/services/forecast_weather_service.dart' as test;
import 'package:ynov_weather/services/weather_service.dart';
import 'package:ynov_weather/widget/form_widget.dart';
import 'package:ynov_weather/models/weather.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WeatherSF();
  }
}

class WeatherSF extends StatefulWidget {
  final City? city;
  const WeatherSF({Key? key, this.city}) : super(key: key);
  @override
  State<WeatherSF> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherSF> {
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
        appBar: AppBar(
          actions: [buildButton()],
          title: const Text("Météo"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder<test2.ForecastWeather>(
                future: test.getForecastWeather('Paris'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("Chargement en cours ..."));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return ListTile(
                              title: Text(
                                snapshot.data!.cnt.toString(),
                              ),
                              subtitle: Text(snapshot.data!.list![i].weather!.first.id.toString()));
                        });
                  } else {
                    return const Text("Une Erreur est survenue");
                  }
                },
              ),
              Form(
                key: _formKey,
                child: FormWidget(
                  name: name,
                  onChangedName: (name) {
                    setState(() => this.name = name);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: addOrUpdateCity,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateCity() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.city != null;

      if (isUpdating) {
        await updateCity();
      } else {
        await addCity();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateCity() async {
    final city = widget.city!.copy(
      name: name,
    );

    await WeatherDatabase.instance.update(city);
  }

  Future addCity() async {
    final city = City(
      name: name,
    );

    await WeatherDatabase.instance.create(city);
  }
}
