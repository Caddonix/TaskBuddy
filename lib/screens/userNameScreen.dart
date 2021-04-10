import 'package:flutter/material.dart';
import 'package:taskbuddy/screens/loginScreen.dart';
import 'package:taskbuddy/utils/inputWithIcon.dart';

class UserNameScreen extends StatelessWidget {

  TextEditingController usernameTextController = TextEditingController();
  Future<void> checkUsername() {
    //ToDo: Check for username availability
    print("Check if username is available");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkUsername(),
          builder: (context, snapshot) {
            return Form(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: Image.asset(
                          'assets/images/username.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    InputWithIcon(
                      btnIcon: Icons.person,
                      hintText: "Username",
                      hintTextStyle: TextStyle(color: Color(0xFF656565)),
                      textStyle: TextStyle(color: Color(0xFFFFF5EE)),
                      myController: usernameTextController,
                      validateFunc: (value) {
                        if (value.isEmpty) {
                          return "Email Required";
                        } else if (!value.contains(RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                          return "Enter valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      child: PrimaryButton(
                        btnText: "Finish",
                      ),
                      onTap: () {
                        print("::::::FINISHED PROCESS::::::::");
                        //ToDo: Complete SignUp
                        Navigator.pushNamed(context, "/");
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
