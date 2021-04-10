import 'package:flutter/material.dart';

class InputWithIcon extends StatefulWidget {
  final IconData btnIcon;
  final String hintText;
  final TextStyle hintTextStyle;
  final TextStyle textStyle;
  final TextEditingController myController;
  final Function(String) validateFunc;
  final Function(String) onChange;
  final bool obscure;
  final TextInputType keyboardType;
  InputWithIcon({
    this.btnIcon,
    this.hintText,
    this.hintTextStyle,
    this.textStyle,
    this.myController,
    this.validateFunc,
    this.onChange,
    this.obscure,
    this.keyboardType,
  });

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.btnIcon,
                size: 20,
                color: Colors.grey.shade500,
              )),
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    fontSize: 9,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: widget.hintTextStyle,
                ),
                style: widget.textStyle,
                autocorrect: false,
                controller: widget.myController,
                validator: widget.validateFunc,
                onChanged: widget.onChange,
                obscureText: widget.obscure ?? false,
                keyboardType: widget.keyboardType ?? TextInputType.emailAddress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}