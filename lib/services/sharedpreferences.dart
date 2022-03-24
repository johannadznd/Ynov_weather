import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

Future setPref(name) async {
  prefs = await SharedPreferences.getInstance();
  prefs.setString("name", name.toString());
}

Future<String?> getPref() async {
  late SharedPreferences prefs;
  prefs = await SharedPreferences.getInstance();
  return prefs.getString("name");
}
