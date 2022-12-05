import 'package:shared_preferences/shared_preferences.dart';

class setloc {
  static dynamic Pref;

  setlocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("locaiton", location);
  }setSublocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sub_locaiton", location);
  }
}
