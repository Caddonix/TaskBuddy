import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/screens/loginScreen.dart';
import 'package:taskbuddy/screens/todo.dart';
import 'package:taskbuddy/screens/userNameScreen.dart';
import 'package:taskbuddy/utils/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NotificationService())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            backgroundColor: Color(0xFF121212),
            scaffoldBackgroundColor: Color(0xFF121212),
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
            )),
        initialRoute: "/login",
        routes: {
          "/": (context) => ToDoScreen(),
          "/login": (context) => LoginScreen(),
          "/username": (context) => UserNameScreen(),
        },
      ),
    );
  }
}
