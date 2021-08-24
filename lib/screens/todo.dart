import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  String getReminderTime(dynamic reminderTime) {
    try{
      if (reminderTime != "null") {
        var timing = DateTime.parse(reminderTime);
        if (timing.isAfter(DateTime.now())) {
          return (timing.hour).toString() + ":" + (timing.minute).toString();
        } else {
          return "";
        }
      }
    }
    catch (e){
      print(e);
      return "";
    }
    return "";
  }

  void fetchToDoList() async {
    Provider.of<NotificationService>(context, listen: false).initialize();
    API api = Provider.of<API>(context, listen: false);
    SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);
    api.fetchToDos(prefs: prefs).then((List<Map<String, dynamic>>? todolist) {
      for (int i = 0; i < todolist!.length; i++) {
        todolist[i]["isExpanded"] = false;
      }
      setState(() {
        todoList = todolist;
      });
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Cannot fetch ToDos! Check your internet connectivity.");
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<NotificationService>(context, listen: false).initialize();
    fetchToDoList();
  }

  @override
  Widget build(BuildContext context) {
    API api = Provider.of<API>(context, listen: false);
    SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Consumer<NotificationService>(
          builder: (context, model, _) => Stack(
            children: [
              if (todoList == null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        "Fetching your ToDos...\n\nCheck your internet if this message persists!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
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
                ReorderableListView.builder(
                  itemCount: todoList!.length,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    final updatedList = todoList;
                    final item = updatedList!.removeAt(oldIndex);
                    updatedList.insert(newIndex, item);
                    bool success = await api.updateToDoList(prefs: prefs, updatedList: updatedList);

                    if (!success) {
                      Fluttertoast.showToast(msg: "Something went wrong!");
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      setState(() {
                        todoList = updatedList;
                        _isLoading = false;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    return Theme(
                      key: Key("$index"),
                      data: ThemeData(
                        unselectedWidgetColor: Colors.white, // Border color for unselected checkbox
                      ),
                      child: ExpansionTile(
                        backgroundColor: Theme.of(context).backgroundColor,
                        collapsedBackgroundColor: Theme.of(context).backgroundColor,
                        leading: Checkbox(
                          checkColor: Colors.indigo,
                          fillColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) return Color(0xFFFFFFFF);
                            return null; // Use the default value.
                          }),
                          value: todoList![index]["isCompleted"],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onChanged: (isCompleted) async {
                            setState(() {
                              _isLoading = true;
                            });
                            todoList![index]["isCompleted"] = isCompleted;
                            bool success = await api.updateToDoList(prefs: prefs, updatedList: todoList!);

                            if (!success) {
                              Fluttertoast.showToast(msg: "Something went wrong!");
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              setState(() {
                                todoList![index]["isCompleted"] = isCompleted;
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                        title: Text(todoList![index]["title"],
                            style: todoList![index]["isCompleted"]
                                ? TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.75),
                                  )
                                : TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                        subtitle: Text(
                          todoList![index]["desc"].length > 30 ? todoList![index]["desc"].substring(0, 30) + "..." : todoList![index]["desc"],
                          style: TextStyle(color: Theme.of(context).accentColor.withOpacity(0.9)),
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            todoList![index]["isExpanded"] = expanded;
                          });
                        },
                        children: [
                          Container(
                            color: Color(0xFF1D1D1D),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(todoList![index]["desc"], style: TextStyle(color: Colors.white70)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Recurring",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                      Transform.scale(
                                        scale: 0.75,
                                        child: CupertinoSwitch(
                                          value: todoList![index]["isRecurr"],
                                          activeColor: Colors.blue,
                                          trackColor: Color(0xFF656565),
                                          onChanged: (bool isRecurring) async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            todoList![index]["isRecurr"] = isRecurring;
                                            bool success = await api.updateToDoList(prefs: prefs, updatedList: todoList!);

                                            if (!success) {
                                              Fluttertoast.showToast(msg: "Something went wrong!");
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } else {
                                              setState(() {
                                                todoList![index]["isRecurr"] = isRecurring;
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      // Private Toggle Button
                                      Text(
                                        "Private",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                      Transform.scale(
                                        scale: 0.75,
                                        child: CupertinoSwitch(
                                          value: todoList![index]["isPrivate"],
                                          activeColor: Colors.pinkAccent,
                                          trackColor: Color(0xFF656565),
                                          onChanged: (bool isPrivate) async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            todoList![index]["isPrivate"] = isPrivate;
                                            bool success = await api.updateToDoList(prefs: prefs, updatedList: todoList!);

                                            if (!success) {
                                              Fluttertoast.showToast(msg: "Something went wrong!");
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } else {
                                              setState(() {
                                                todoList![index]["isPrivate"] = isPrivate;
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.alarm,
                                          size: 30,
                                          color: Color(0xFFFFF5EE),
                                        ),
                                        onPressed: () async {
                                          final TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _initialTime,
                                          );
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          DateTime? date;
                                          final now = DateTime.now();
                                          if (pickedTime != null) {
                                            date = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                            todoList![index]["reminder"] = date.toString();
                                            bool success = await api.updateToDoList(prefs: prefs, updatedList: todoList!);

                                            if (!success) {
                                              Fluttertoast.showToast(msg: "Something went wrong!");
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            } else {
                                              setState(() {
                                                todoList![index]["reminder"] = date;
                                                _isLoading = false;
                                              });
                                              model.scheduledNotification(
                                                id: int.parse(todoList![index]["reminder"].toString().substring(4,16).replaceAll(RegExp('[^0-9]'), '')),
                                                title: todoList![index]["title"],
                                                body: todoList![index]["desc"],
                                                dateTime: date,
                                              );
                                            }
                                          } else {
                                            Fluttertoast.showToast(msg: "Something went wrong!");
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        },
                                      ),
                                      Text(getReminderTime(todoList![index]["reminder"].toString()))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        trailing: (todoList![index]["isExpanded"])
                            ? IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Color(0xFFFFF5EE),
                                  size: 20,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var updatedList = todoList;
                                  updatedList!.removeAt(index);
                                  bool success = await api.updateToDoList(prefs: prefs, updatedList: updatedList);

                                  if (!success) {
                                    Fluttertoast.showToast(msg: "Something went wrong!");
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      todoList = updatedList;
                                      _isLoading = false;
                                    });
                                  }
                                },
                              )
                            : Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white.withOpacity(0.5),
                              ),
                      ),
                    );
                  },
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
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                        child: Center(
                          child: CircularProgressIndicator(),
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
            SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);
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
      ),
    );
  }
}
