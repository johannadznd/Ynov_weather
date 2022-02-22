import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/views/weather.dart';
import 'package:ynov_weather/models/weather.dart';

class testPage extends StatefulWidget {
  const testPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<testPage> {
  late List<City> cities;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshCity();
  }

  @override
  void dispose() {
    WeatherDatabase.instance.close();

    super.dispose();
  }

  Future refreshCity() async {
    setState(() => isLoading = true);

    cities = await WeatherDatabase.instance.readAllCities();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Ville',
            style: TextStyle(fontSize: 24),
          ),
          actions: const [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : cities.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildCities(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WeatherPage()),
            );

            refreshCity();
          },
        ),
      );

  Widget buildCities() => ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(cities[i].name.toString()),
          subtitle: Column(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    if (isLoading) return;

                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => WeatherSF(city : cities[i]),
                    ));
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
