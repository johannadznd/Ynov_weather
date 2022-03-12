import 'package:flutter/material.dart';
import 'package:ynov_weather/models/meteo.dart';

class WeatherDayWidget extends StatelessWidget {
  final String? name;
  final BuildContext context;
  final AsyncSnapshot<Meteo> snapshot;
  final String date;
  final String icon;

  const WeatherDayWidget({
    Key? key,
    this.name = '',
    required this.context,
    required this.snapshot,
    required this.date,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.blueGrey.shade100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                const Icon(
                  Icons.location_on_outlined,
                ),
                Text(name!, style: const TextStyle(fontSize: 18)),
              ]),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Text(date),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Image(
                      image: NetworkImage(icon),
                    ),
                    Text(snapshot.data!.main!.temp!.toStringAsFixed(0) + '°',
                        style: const TextStyle(fontSize: 25)),
                    const Spacer(
                      flex: 10,
                    ),
                    Column(children: [
                      Text(
                        'Humidité : ' +
                            snapshot.data!.main!.humidity.toString() +
                            '%',
                      ),
                      Text(
                        'Vent : ' +
                            (snapshot.data!.wind!.speed! * 3.6)
                                .toStringAsFixed(0) +
                            'km/h',
                      ),
                    ])
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
