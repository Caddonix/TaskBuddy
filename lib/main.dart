import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbuddy/api.dart';
import 'package:taskbuddy/landingPage.dart';
import 'package:taskbuddy/screens/homePage.dart';
import 'package:taskbuddy/screens/loginScreen.dart';
import 'package:taskbuddy/screens/settingsScreen.dart';
import 'package:taskbuddy/screens/todo.dart';
import 'package:taskbuddy/utils/authentication/authService.dart';
import 'package:taskbuddy/utils/authentication/user.dart';
import 'package:taskbuddy/utils/notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  tz.initializeTimeZones();
  runApp(MyApp(preferences: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  MyApp({required this.preferences});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationService()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<API>(create: (_) => API()),
        Provider<SharedPreferences>(create: (_) => preferences),
        // FutureProvider<User?>(
        //   create: (context) async {
        //     var prefs = Provider.of<SharedPreferences>(context, listen: false);
        //     var pairedUser = await Provider.of<API>(context, listen: false).pairedUser(prefs: prefs);
        //     return pairedUser;
        //   },
        //   initialData: null,
        // ),
      ],
      child: MaterialApp(
        title: 'Lots ToDo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          backgroundColor: Color(0xFF121212),
          scaffoldBackgroundColor: Color(0xFF121212),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            headline2: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            headline3: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            headline4: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            headline5: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            headline6: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFFF5EE)),
            bodyText2: TextStyle(fontSize: 14, color: Color(0xFFFFF5EE)),
          ),
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => LandingPage(),
          "/login": (context) => LoginScreen(),
          "/home": (context) => HomePage(),
          "/todos": (context) => ToDoScreen(),
          "/settings": (context) => SettingsScreen(),
        },
      ),
    );
  }
}
