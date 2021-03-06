import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbuddy/screens/homePage.dart';
import 'package:taskbuddy/screens/loginScreen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LandingPage extends StatelessWidget {
  late IO.Socket socket;

  @override
  Widget build(BuildContext context) {
    final SharedPreferences prefs = Provider.of<SharedPreferences>(context);
    if (prefs.getString('email') != null) {
      return HomePage();
    } else {
      return LoginScreen();
    }
  }
}
