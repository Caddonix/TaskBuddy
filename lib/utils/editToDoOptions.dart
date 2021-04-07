import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditToDoOptions extends StatefulWidget {
  EditToDoOptions({this.toDoList, this.index});
  final List toDoList;
  final int index;

  @override
  _EditToDoOptionsState createState() => _EditToDoOptionsState();
}

class _EditToDoOptionsState extends State<EditToDoOptions> {
  Widget tagButton(index, i) {
    var tags = widget.toDoList[index]["tags"];
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        child: Container(
          height: MediaQuery.of(context).size.width * 0.075,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).accentColor
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
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
                  "Edit Tag",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 1,
                      fontSize: 20),
                ),
                children: [
                  Text("Fields to edit the tag"),
                ],
              ),
            );
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1D1D1D),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Tag Suggestions"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tagButton(widget.index, 0),
                tagButton(widget.index, 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tagButton(widget.index, 2),
                tagButton(widget.index, 3),
              ],
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
                    value: widget.toDoList[widget.index]["isRecurring"],
                    activeColor: Colors.blue,
                    trackColor: Color(0xFF656565),
                    onChanged: (bool value) {
                      setState(() {
                        widget.toDoList[widget.index]["isRecurring"] = value;
                      });
                    },
                  ),
                ),

                SizedBox(height: 8),
                // Private Toggle Button
                Text(
                  "Private",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Transform.scale(
                  scale: 0.75,
                  child: CupertinoSwitch(
                    value: widget.toDoList[widget.index]["isPrivate"],
                    activeColor: Colors.pinkAccent,
                    trackColor: Color(0xFF656565),
                    onChanged: (bool value) {
                      setState(() {
                        widget.toDoList[widget.index]["isPrivate"] = value;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {}, child: Text("Save")),
                )
              ],
            ),
            //
            // Row(
            //   children: [
            //
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
