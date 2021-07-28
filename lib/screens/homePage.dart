import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/todo.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab( text: "ToDos",),
              Tab(text: "Pair",),
              Tab(text: "Pair ToDos"),
            ],
          ),
          title: const Text('Lots ToDo'),
        ),
        body: TabBarView(
          children: [
            ToDoScreen(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
