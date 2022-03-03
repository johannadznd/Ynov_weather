import 'package:flutter/material.dart';
import 'package:ynov_weather/models/forecast_weather.dart';

class ForecastWeatherWidget extends StatelessWidget {
  final int i;
  final AsyncSnapshot<ForecastWeather> snapshot;
  final String date;
  final String icon;

  const ForecastWeatherWidget({
    Key? key,
    required this.snapshot,
    required this.date,
    required this.icon,
    required this.i,
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
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Text(date),
            const Spacer(
              flex: 2,
            ),
            Image(
              width: 50,
              image: NetworkImage(icon),
            ),
            const Spacer(
              flex: 2,
            ),
            Text(
              snapshot.data!.list![i].main!.temp!.toStringAsFixed(0) + '°',
            ),
          ],
        ),
      ));
}
