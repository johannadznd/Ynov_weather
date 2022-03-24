import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynov_weather/db/weather.dart';
import 'package:ynov_weather/models/weather.dart';
import 'package:ynov_weather/views/weather.dart';
import 'package:ynov_weather/widget/form_widget.dart';

class buildPopupDialog extends StatefulWidget {
  final City? city;
  const buildPopupDialog({Key? key, this.city}) : super(key: key);
  @override
  State<buildPopupDialog> createState() => _buildPopupDialogState();
}

class _buildPopupDialogState extends State<buildPopupDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    name = widget.city?.name ?? '';
  }

  save(name) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name.toString());
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Ajouter une ville'),
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: FormWidget(
                  name: widget.city?.name,
                  onChangedName: (name) {
                    setState(() => this.name = name);
                  },
                ),
              ),
              buildButton(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget buildButton() {
    return AnimatedButton(
      onPressed: addOrUpdateCity,
      color: Colors.black,
      height: 40,
      width: 120,
      child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
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
    }
  }

  Future updateCity() async {
    final city = widget.city!.copy(
      name: name,
    );

    await WeatherDatabase.instance.update(city);

    await save(name);

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WeatherPage()),
    );
  }

  Future addCity() async {
    final city = City(
      name: name,
    );

    await WeatherDatabase.instance.create(city);

    await save(name);

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => WeatherPage()),
    );
  }
}
