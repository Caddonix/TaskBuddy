import 'package:flutter/material.dart';

class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({required this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(15),
      child: Center(
          child: Text(
        widget.btnText,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
      )),
    );
  }
}
