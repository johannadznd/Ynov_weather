import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/views/weather.dart';
import 'package:ynov_weather/models/weather.dart';
import 'package:ynov_weather/widget/dialog_widget.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<City> cities;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshCity();
  }

  Future refreshCity() async {
    setState(() => isLoading = true);

    cities = await WeatherDatabase.instance.readAllCities();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 80),
          children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              child: const Center(
                child: Text(
                  "Mes villes",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black)),
                  child: const Text('Ajouter une ville'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => buildPopupDialog(),
                    );
                    refreshCity();
                  },
                ),
              ),
            ),
            Container(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : cities.isEmpty
                      ? const Text(
                          'Vous n\'avez pas rensigner de villes',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.center,
                        )
                      : buildCities(),
            ),
          ],
        ),
      );

  Widget buildCities() => ListView.builder(
      shrinkWrap: true,
      itemCount: cities.length,
      itemBuilder: (context, i) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WeatherPage(city: cities[i]),
                  ));
                },
                child: Text(
                  cities[i].name.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    if (isLoading) return;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          buildPopupDialog(city: cities[i]),
                    );

                    refreshCity();
                  }),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await WeatherDatabase.instance.delete(cities[i].id!.toInt());
                  refreshCity();
                },
              )
            ],
          ),
        );
      });
}