import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskToDo extends StatefulWidget {
  @override
  _TaskToDoState createState() => _TaskToDoState();
}

class _TaskToDoState extends State<TaskToDo> {
  bool _isRecurring = false;
  bool _isPrivate = false;
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),

          // Header Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Task ToDo",
                style: Theme.of(context).textTheme.headline4,
              ),
              Column(
                children: [
                  // Recurring Toggle Button
                  Text(
                    "Recurring",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  CupertinoSwitch(
                    value: _isRecurring,
                    activeColor: Colors.blue,
                    trackColor: Color(0xFF656565),
                    onChanged: (bool value) {
                      setState(() {
                        _isRecurring = value;
                      });
                    },
                  ),

                  SizedBox(height: 8),
                  // Private Toggle Button
                  Text(
                    "Private",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  CupertinoSwitch(
                    value: _isPrivate,
                    activeColor: Colors.pinkAccent,
                    trackColor: Color(0xFF656565),
                    onChanged: (bool value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),

          // Data Fields
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _taskDescriptionController,
                    maxLines : 5,
                    minLines: 2,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
