import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbuddy/api.dart';
import 'package:taskbuddy/utils/UIElements/primaryButton.dart';
import 'package:taskbuddy/utils/notifications.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key, required this.categories}) : super(key: key);
  final List<String> categories;
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isRecurring = false;
  bool isPrivate = false;
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay? _pickedTime;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<NotificationService>(
          builder: (context, model, _) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Lots ToDo",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 20),
                    TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _categoryController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24)),
                          border: OutlineInputBorder(),
                          labelText: "Category",
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      suggestionsCallback: (query) {
                        return widget.categories.where((element) {
                          try {
                            return element.toString().contains(
                                  RegExp(
                                    query,
                                    caseSensitive: false,
                                  ),
                                );
                          } catch (e) {
                            print(e);
                            return false;
                          }
                        }).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (String suggestion) {
                        setState(() {
                          _categoryController.text = suggestion;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please select a ToDo category!";
                        } else if (!widget.categories.contains(value)) {
                          return "Please select a category from the list!";
                        }
                        return null;
                      },
                      noItemsFoundBuilder: (context) {
                        return ListTile(
                          title: Text("No category found"),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descController,
                      style: TextStyle(color: Colors.white70),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        border: OutlineInputBorder(),
                        labelText: "Description",
                        hintText: "Describe your ToDo",
                        hintStyle: TextStyle(color: Colors.white54),
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      maxLines: 5,
                      minLines: 2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please describe your ToDo!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        // Private Toggle Button
                        Transform.scale(
                          scale: 0.75,
                          child: CupertinoSwitch(
                            value: isPrivate,
                            activeColor: Colors.pinkAccent,
                            trackColor: Color(0xFF656565),
                            onChanged: (bool value) {
                              setState(() {
                                isPrivate = !isPrivate;
                              });
                            },
                          ),
                        ),

                        Text(
                          "Keep this ToDo private?",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        // Private Toggle Button
                        Transform.scale(
                          scale: 0.75,
                          child: CupertinoSwitch(
                            value: isRecurring,
                            activeColor: Colors.blue,
                            trackColor: Color(0xFF656565),
                            onChanged: (bool value) {
                              setState(() {
                                isRecurring = !isRecurring;
                              });
                            },
                          ),
                        ),
                        Text(
                          "Repeat this ToDo after 24 hours?",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                          _pickedTime = pickedTime;
                        });
                        model.instantNotification();
                      },
                    ),
                    PrimaryButton(
                      btnText: 'Add ToDo',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final now =  DateTime.now();
                          DateTime date = DateTime(now.year, now.month, now.day, _pickedTime!.hour, _pickedTime!.minute);
                          var todo = {
                            "title": _categoryController.text,
                            "desc": _descController.text,
                            "isRecurr": isRecurring,
                            "isPrivate": isPrivate,
                            "isCompleted": false,
                            "reminder": date.millisecondsSinceEpoch,
                          };

                          API api = Provider.of<API>(context, listen: false);
                          SharedPreferences prefs =
                              Provider.of<SharedPreferences>(context, listen: false);

                          List<Map<String, dynamic>>? todoList = await api.fetchToDos(prefs: prefs);
                          todoList!.add(todo);

                          var success =
                              await api.saveToDo(prefs: prefs, updatedList: todoList);
                          // if (success)
                          //   Navigator.pushNamedAndRemoveUntil(
                          //       context, "/", (route) => false);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
