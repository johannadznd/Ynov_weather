import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:ynov_weather/models/forecast_weather.dart';

Future<ForecastWeather> getForecastWeather(name) async {
  List<Location> coords = await locationFromAddress(name);
  late ListHours hours;

  Uri url = Uri.https("api.openweathermap.org", "/data/2.5/forecast/", {
    'lat': coords[0].latitude.toString(),
    'lon': coords[0].longitude.toString(),
    'lang': 'fr',
    'units': 'Metric',
    'appid': 'f46840b0403f41348c5ee528a73851de'
  });

  print(url);
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<ListHours> listHours = [];
    for (var i = 0; i < jsonResponse['list'].length; i++) {
      Weather meteo = Weather(
          id: jsonResponse['list'][i]['weather'][0]['id'],
          main: jsonResponse['list'][i]['weather'][0]['main'],
          description: jsonResponse['list'][i]['weather'][0]['description'],
          icon: jsonResponse['list'][i]['weather'][0]['icon']);

      hours = ListHours(
        dt: jsonResponse['list'][i]['dt'],
        main: Main(
          temp: jsonResponse['list'][i]['main']['temp'].toDouble(),
          feelsLike: jsonResponse['list'][i]['main']['feels_like'].toDouble(),
          tempMin: jsonResponse['list'][i]['main']['temp_min'].toDouble(),
          tempMax: jsonResponse['list'][i]['main']['temp_max'].toDouble(),
          pressure: jsonResponse['list'][i]['main']['pressure'],
          seaLevel: jsonResponse['list'][i]['main']['sea_level'],
          grndLevel: jsonResponse['list'][i]['main']['grnd_level'],
          humidity: jsonResponse['list'][i]['main']['humidity'],
          tempKf: jsonResponse['list'][i]['main']['temp_kf'].toDouble(),
        ),
        weather: List<Weather>.filled(1, meteo),
        clouds: Clouds(all: jsonResponse['list'][i]['clouds']['all']),
        wind: Wind(
          speed: jsonResponse['list'][i]['wind']['speed'].toDouble(),
          deg: jsonResponse['list'][i]['wind']['deg'],
          gust: jsonResponse['list'][i]['wind']['gust'].toDouble(),
        ),
        visibility: jsonResponse['list'][i]['visibility'],
        pop: jsonResponse['list'][i]['pop'].toDouble(),
        sys: Sys(pod: jsonResponse['list'][i]['sys']['pod']),
        dtTxt: jsonResponse['list'][i]['dtTxt'],
      );

      listHours.add(hours);
    }

    ForecastWeather weather = ForecastWeather(
        cod: jsonResponse['cod'],
        message: jsonResponse['message'],
        cnt: jsonResponse['cnt'],
        list: listHours);
    return weather;
  } else {
    print('Request failed : ${response.statusCode}');
    return ForecastWeather();
  }
}
