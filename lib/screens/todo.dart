import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbuddy/screens/addToDo.dart';
import 'package:taskbuddy/utils/notifications.dart';

import '../api.dart';

class ToDoScreen extends StatefulWidget {
  ToDoScreen({Key? key}) : super(key: key);
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TimeOfDay _initialTime = TimeOfDay.now();
  TextEditingController tagController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>>? todoList;

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
                todoList!.removeAt(index);
              });
              Navigator.pop(context);
            },
          );
        });
  }

  void fetchToDoList() async {
    Provider.of<NotificationService>(context, listen: false).initialize();
    API api = Provider.of<API>(context, listen: false);
    SharedPreferences prefs =
        Provider.of<SharedPreferences>(context, listen: false);
    api.fetchToDos(prefs: prefs).then((List<Map<String, dynamic>>? todolist) {
      setState(() {
        print(todolist);
        todoList = todolist;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<NotificationService>(
          builder: (context, model, _) => Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "Lots ToDo",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    "Today",
                    style: TextStyle(
                        color: Color(0xFF656565),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  if (todoList == null)
                    Center(
                      child: Text(
                        "Oops! Something went wrong!\n\nCheck your internet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else if (todoList!.length == 0)
                    Center(
                      child: Text(
                        "No ToDos found!\n\nAdd a new ToDo by clicking the + button.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: todoList!.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final items = todoList!.removeAt(oldIndex);
                            todoList!.insert(newIndex, items);
                          });
                        },
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            key: Key("$index"),
                            backgroundColor: Theme.of(context).backgroundColor,
                            collapsedBackgroundColor:
                                Theme.of(context).backgroundColor,
                            leading: Theme(
                              data: ThemeData(
                                unselectedWidgetColor:
                                    Colors.white, // Border color
                              ),
                              child: Checkbox(
                                checkColor: Colors.indigo,
                                fillColor: MaterialStateProperty.resolveWith(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected))
                                    return Color(0xFFFFFFFF);
                                  return null; // Use the default value.
                                }),
                                value: todoList![index]["isCompleted"],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    todoList![index]["isCompleted"] = newValue;
                                  });
                                },
                              ),
                            ),
                            title: Text(todoList![index]["title"],
                                style: todoList![index]["isCompleted"]
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      )
                                    : TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      )),
                            children: [
                              Container(
                                color: Color(0xFF1D1D1D),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(color: Colors.white70),
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white24)),
                                          border: OutlineInputBorder(),
                                          labelText: "Description",
                                          hintText: "Describe your ToDo",
                                          hintStyle:
                                              TextStyle(color: Colors.white54),
                                          labelStyle:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        initialValue: todoList![index]["desc"],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Recurring",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                          Transform.scale(
                                            scale: 0.75,
                                            child: CupertinoSwitch(
                                              value: todoList![index]
                                                  ["isRecurr"],
                                              activeColor: Colors.blue,
                                              trackColor: Color(0xFF656565),
                                              onChanged: (bool value) {
                                                setState(() {
                                                  todoList![index]["isRecurr"] =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                          // Private Toggle Button
                                          Text(
                                            "Private",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                          Transform.scale(
                                            scale: 0.75,
                                            child: CupertinoSwitch(
                                              value: todoList![index]
                                                  ["isPrivate"],
                                              activeColor: Colors.pinkAccent,
                                              trackColor: Color(0xFF656565),
                                              onChanged: (bool value) {
                                                setState(() {
                                                  todoList![index]
                                                      ["isPrivate"] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.alarm,
                                              size: 30,
                                              color: Color(0xFFFFF5EE),
                                            ),
                                            onPressed: () async {
                                              final TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                context: context,
                                                initialTime: _initialTime,
                                              );
                                              setState(() {
                                                todoList![index]["reminder"] =
                                                    pickedTime;
                                                print(todoList![index]
                                                    ["reminder"]);
                                              });
                                              model.instantNotification();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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

              // Loading widget
              if (_isLoading)
                Center(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                        child: Center(
                          child: SizedBox(
                            height: 75,
                            width: 75,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SizedBox()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            API api = Provider.of<API>(context, listen: false);
            SharedPreferences prefs =
                Provider.of<SharedPreferences>(context, listen: false);
            List<String> categories = await api.fetchCategories(prefs: prefs);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddToDo(categories: categories),
              ),
            ).whenComplete(fetchToDoList);
            setState(() {
              _isLoading = false;
            });
          },
          tooltip: 'Add ToDo',
          child: Icon(Icons.add),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
