import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/chatPage.dart';
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
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case 0: // Saved Chats clicked
                    Navigator.pushNamed(context, "/savedchats");
                    break;
                  case 1: // Settings clicked
                    Navigator.pushNamed(context, "/settings");
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(child: Text("Saved Chats"), value: 0),
                  PopupMenuItem(child: Text("Settings"), value: 1),
                ];
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "My ToDos"),
              Tab(text: "Chat"),
              Tab(text: "Buddy ToDos"),
            ],
          ),
          title: const Text('Lots ToDo'),
        ),
        body: TabBarView(
          children: [
            ToDoScreen(),
            ChatPage(),
            Center(child: Text("ToDos of the buddy will be here")),
          ],
        ),
      ),
    );
  }
}
