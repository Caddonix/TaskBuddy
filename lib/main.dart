import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/loginScreen.dart';
import 'package:taskbuddy/screens/todo.dart';
import 'package:taskbuddy/screens/userNameScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
    );
  }
}
