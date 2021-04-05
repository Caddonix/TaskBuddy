import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/taskToDoScreen.dart';

class ToDoScreen extends StatefulWidget {
  ToDoScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List todoList = [
    {
      "title": "Purva",
      "isCompleted": true,
    },
    {
      "title": "Abby",
      "isCompleted": true,
    },
    {
      "title": "1234",
      "isCompleted": true,
    },
    {
      "title": "5678",
      "isCompleted": true,
    },
    {
      "title": "9",
      "isCompleted": true,
    },
    {
      "title": "10",
      "isCompleted": true,
    },
    {
      "title": "Abby Sanika, Parvathy, Pratam, Donovan",
      "isCompleted": true,
    },
  ];

  void editOptions(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.18,
            decoration: BoxDecoration(
              color: Color(0xFFFFF5EE),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text(
                    'Edit ToDo',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red,),
                  title: Text(
                    'Delete ToDo',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  onTap: () {
                    setState(() {
                      todoList.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          ListTile(
            title: Text(
              "To Do",
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: Text("Today",
                style: TextStyle(
                    color: Color(0xFF656565),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: todoList.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final items = todoList.removeAt(oldIndex);
                  todoList.insert(newIndex, items);
                });
              },
              itemBuilder: (context, index) {
                return ListTile(
                  key: Key("$index"),
                  tileColor: Theme.of(context).backgroundColor,
                  leading: CircularCheckBox(
                    activeColor: Colors.indigo,
                    inactiveColor: Color(0xFF656565),
                    value: todoList[index]["isCompleted"],
                    onChanged: (newValue) {
                      setState(() {
                        todoList[index]["isCompleted"] = newValue;
                      });
                    },
                  ),
                  title: Text(
                    todoList[index]["title"],
                    style: todoList[index]["isCompleted"]
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Color(0xFF656565),
                          )
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Color(0xFFFFF5EE),
                      size: 20,
                    ),
                    onPressed: () {
                      editOptions(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TaskToDo()));
        },
        tooltip: 'Add ToDo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
