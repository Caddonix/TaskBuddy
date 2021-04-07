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
      "tags": ["reading", "writing", "coding", "dev", "sleeping"],
    },
    {
      "title": "Abby",
      "isCompleted": true,
      "tags": ["coding", "dev", "sleeping", ""],
    },
    {
      "title": "1234",
      "isCompleted": true,
      "tags": ["sleeping", "cooking", "", ""],
    },
    {
      "title": "5678",
      "isCompleted": true,
      "tags": ["reading", "writing", "", ""],
    },
    {
      "title": "5678",
      "isCompleted": true,
      "tags": ["reading", "writing", "", ""],
    },
  ];

  Widget tagButton(index, i) {
    var tags = todoList[index]["tags"];
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => SimpleDialog(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            backgroundColor: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Edit Tag",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1,
                  fontSize: 20),
            ),
            children: [
              
            ],
          ),
        );
      },
      child: tags[i] != ""
          ? Text(tags[i])
          : Text(
              "Add Tag",
              style: TextStyle(fontSize: 12.0),
            ),
      style: OutlinedButton.styleFrom(
        // shadowColor: Colors.white,
        side: BorderSide(width: 0.5, color: Colors.white),
      ),
    );
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
                var tags = todoList[index]["tags"];
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tagButton(index, 0),
                        tagButton(index, 1),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tagButton(index, 2),
                        tagButton(index, 3),
                      ],
                    ),
                  ],
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Color(0xFFFFF5EE),
                      size: 20,
                    ),
                    onPressed: () {},
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
