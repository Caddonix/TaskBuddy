import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskbuddy/utils/inputWithIcon.dart';
import 'package:taskbuddy/utils/notifications.dart';

class ToDoScreen extends StatefulWidget {
  ToDoScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<FormState> _tagFormKey = GlobalKey();
  TimeOfDay _initialTime = TimeOfDay.now();
  final List todoList = [
    {
      "title": "Purva",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "reminder": null,
      "tags": ["reading", "writing", "coding", "dev", "sleeping"],
    },
    {
      "title": "Abby",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "reminder": null,
      "tags": ["coding", "dev", "sleeping", ""],
    },
    {
      "title": "Prasad",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "reminder": null,
      "tags": ["sleeping", "cooking", "", ""],
    },
    {
      "title": "Muskan",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "reminder": null,
      "tags": ["reading", "writing", "", ""],
    },
    {
      "title": "Kushal",
      "isCompleted": false,
      "isPrivate": false,
      "isRecurring": false,
      "reminder": null,
      "tags": ["reading", "writing", "", ""],
    },
  ];

  Widget tagButton(index, i) {
    var tags = todoList[index]["tags"];
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.width * 0.075,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: tags[i] != ""
                ? Text(tags[i])
                : Text(
                    "Add Tag",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => SimpleDialog(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: Color(0xFF1D1D1D),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Task Tag",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1,
                    fontSize: 20),
              ),
              children: [
                Form(
                  key: _tagFormKey,
                  child: InputWithIcon(
                    btnIcon: Icons.tag,
                    hintText: "Tag",
                    hintTextStyle: TextStyle(color: Color(0xFF656565)),
                    textStyle: TextStyle(color: Color(0xFFFFF5EE)),
                    validateFunc: (value) {
                      if (value.isEmpty) {
                        return "Empty Tag";
                      }
                      return null;
                    },
                    onChange: (value) {
                      _tagFormKey.currentState.validate();
                      setState(() {
                        todoList[index]["tags"][i] = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
  void initState() {
    super.initState();
    Provider.of<NotificationService>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationService>(
        builder: (context, model, _) => Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ListTile(
              title: Text(
                "Lots ToDo",
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
                    leading: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.white, // Border color
                      ),
                      child: Checkbox(
                        checkColor: Colors.indigo,
                        fillColor: MaterialStateProperty.resolveWith(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected))
                            return Color(0xFFFFFFFF);
                          return null; // Use the default value.
                        }),
                        value: todoList[index]["isCompleted"],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            todoList[index]["isCompleted"] = newValue;
                          });
                        },
                      ),
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
                      Container(
                        color: Color(0xFF1D1D1D),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: TextFormField(
                                    // controller: editToDo,
                                    minLines: 1,
                                    maxLines: 3,
                                    initialValue: todoList[index]["title"],
                                    validator: (value) {
                                      if (value.length == 0) {
                                        return "Enter ToDo Title";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _formKey.currentState.validate();
                                      setState(() {
                                        todoList[index]["title"] = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: Color(0xFFFFF5EE),
                                        size: 20,
                                      ),
                                      hintText: 'ToDo Title',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFFFF5EE)),
                                    ),
                                    style: TextStyle(color: Color(0xFFFFF5EE)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 7.5,
                              ),
                              Text("Tag Suggestions"),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Recurring",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: CupertinoSwitch(
                                      value: todoList[index]["isRecurring"],
                                      activeColor: Colors.blue,
                                      trackColor: Color(0xFF656565),
                                      onChanged: (bool value) {
                                        setState(() {
                                          todoList[index]["isRecurring"] =
                                              value;
                                        });
                                      },
                                    ),
                                  ),
                                  // SizedBox(height: 8),
                                  // Private Toggle Button
                                  Text(
                                    "Private",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: CupertinoSwitch(
                                      value: todoList[index]["isPrivate"],
                                      activeColor: Colors.pinkAccent,
                                      trackColor: Color(0xFF656565),
                                      onChanged: (bool value) {
                                        setState(() {
                                          todoList[index]["isPrivate"] = value;
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
                                      final TimeOfDay pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: _initialTime,
                                      );
                                      setState(() {
                                        todoList[index]["reminder"] =
                                            pickedTime;
                                        print(todoList[index]["reminder"]);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add ToDo',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
