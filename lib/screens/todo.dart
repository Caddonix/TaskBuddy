import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/taskToDoScreen.dart';
import 'package:taskbuddy/utils/editToDoOptions.dart';

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
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "tags": ["reading", "writing", "coding", "dev", "sleeping"],
    },
    {
      "title": "Abby",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "tags": ["coding", "dev", "sleeping", ""],
    },
    {
      "title": "1234",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "tags": ["sleeping", "cooking", "", ""],
    },
    {
      "title": "5678",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "tags": ["reading", "writing", "", ""],
    },
    {
      "title": "5678",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "tags": ["reading", "writing", "", ""],
    },
  ];

  void deleteToDoItem(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListTile(
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: Text(
              'Confirm Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            onTap: () {
              setState(() {
                todoList.removeAt(index);
              });
              Navigator.pop(context);
            },
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
            subtitle: Text(
              "Today",
              style: TextStyle(
                  color: Color(0xFF656565),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
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
                return ExpansionTile(
                  key: Key("$index"),
                  backgroundColor: Theme.of(context).backgroundColor,
                  collapsedBackgroundColor: Theme.of(context).backgroundColor,
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
                  children: [
                    EditToDoOptions(
                      toDoList: todoList,
                      index: index,
                    ),
                  ],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xFFFFF5EE),
                      size: 20,
                    ),
                    onPressed: () {
                      deleteToDoItem(index);
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskToDo()));
        },
        tooltip: 'Add ToDo',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
