import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:ynov_weather/models/meteo.dart';

Future<Meteo> getWeather(name) async {
  List<Location> coords = await locationFromAddress(name);

  Uri url = Uri.https("api.openweathermap.org", "/data/2.5/weather", {
    'lat': coords[0].latitude.toString(),
    'lon': coords[0].longitude.toString(),
    'lang': 'fr',
    'units': 'Metric',
    'appid': 'f46840b0403f41348c5ee528a73851de',
  });

  print(url);

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    Weather weather = Weather(
        id: jsonResponse['weather'][0]['id'],
        main: jsonResponse['weather'][0]['main'],
        description: jsonResponse['weather'][0]['description'],
        icon: jsonResponse['weather'][0]['icon']);

    Meteo meteo = Meteo(
      coord: Coord(
          lon: jsonResponse['coord']['lon'], lat: jsonResponse['coord']['lat']),
      base: jsonResponse['base'],
      main: Main(
          temp: jsonResponse['main']['temp'].toDouble(),
          feelsLike: jsonResponse['main']['feels_like'].toDouble(),
          tempMin: jsonResponse['main']['temp_min'].toDouble(),
          tempMax: jsonResponse['main']['temp_max'].toDouble(),
          pressure: jsonResponse['main']['pressure'],
          humidity: jsonResponse['main']['humidity']),
      visibility: jsonResponse['visibility'],
      wind: Wind(
          speed: jsonResponse['wind']['speed'].toDouble(),
          deg: jsonResponse['wind']['deg']),
      clouds: Clouds(all: jsonResponse['clouds']['all']),
      dt: jsonResponse['dt'],
      sys: Sys(
          type: jsonResponse['sys']['type'],
          id: jsonResponse['sys']['id'],
          message: jsonResponse['sys']['message'],
          country: jsonResponse['sys']['country'],
          sunrise: jsonResponse['sys']['sunrise'],
          sunset: jsonResponse['sys']['sunset']),
      timezone: jsonResponse['timezone'],
      id: jsonResponse['id'],
      name: jsonResponse['name'],
      cod: jsonResponse['cod'],
      weather: List<Weather>.filled(1, weather),
    );

    return meteo;
  } else {
    print('Request failed : ${response.statusCode}');
    return Meteo();
  }
}
