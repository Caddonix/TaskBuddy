import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool _isLoading = false;

  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay? _pickedTime;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<NotificationService>(
          builder: (context, model, _) => Stack(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Add ToDo",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _descController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            border: OutlineInputBorder(),
                            labelText: "ToDo",
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
                        SizedBox(height: 20),
                        TypeAheadFormField<String>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _categoryController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
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
                                onChanged: (bool value) async {
                                  setState(() {
                                    isRecurring = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              "Repeat this ToDo daily?",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.alarm,
                                size: 30,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () async {
                                final TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: _initialTime,
                                );
                                setState(() {
                                  _pickedTime = pickedTime;
                                });
                              },
                            ),
                            Text(
                              "Set a reminder for this ToDo",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        PrimaryButton(
                          btnText: 'Add ToDo',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _isLoading = true;
                              });
                              DateTime? date;
                              final now = DateTime.now();
                              if (_pickedTime != null) {
                                date = DateTime(now.year, now.month, now.day, _pickedTime!.hour, _pickedTime!.minute);
                                model.scheduledNotification(
                                  id: 0,
                                  title: _categoryController.text,
                                  body: _descController.text,
                                  dateTime: date,
                                );
                              }
                              var todo = {
                                "title": _categoryController.text, // String
                                "desc": _descController.text, // String
                                "isRecurr": isRecurring, // bool
                                "isPrivate": isPrivate, // bool
                                "isCompleted": false, // bool
                                "reminder": date != null ? date.toString() : null, // String
                                "created_at": DateTime.now().toString() // String
                              };

                              API api = Provider.of<API>(context, listen: false);
                              SharedPreferences prefs = Provider.of<SharedPreferences>(context, listen: false);

                              List<Map<String, dynamic>>? todoList = await api.fetchToDos(prefs: prefs);
                              todoList!.add(todo);

                              var success = await api.updateToDoList(prefs: prefs, updatedList: todoList);
                              if (success)
                                Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                              else
                                Fluttertoast.showToast(msg: "Something went wrong! Try again.");
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
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
      ),
    );
  }
}
