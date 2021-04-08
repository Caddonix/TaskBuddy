import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskbuddy/utils/inputWithIcon.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Declaring Necessary Variables
  int _pageState = 0;
  bool forgetPassClick = false;
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var _backgroundColor = Color(0xFFBFEEFEC);
  var _headingColor = Color(0xFFB1E4155);
  var _arrowColor = Color(0xFFBFEEFEC);

  double _headingTop = 120;
  double _loginYOffset = 0;
  double _registerYOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of the Screen
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    switch (_pageState) {
      case 0:
        _backgroundColor = Color(0xFFFFFFFF);
        _headingColor = Color(0xFF121212);
        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _headingTop = 60;
        _arrowColor = Color(0xFFFFFFFF);
        break;
      case 1:
        _backgroundColor = Color(0xFF1D1D1D);
        _headingColor = Colors.white;
        _loginYOffset = 200;
        _registerYOffset = windowHeight;
        _headingTop = 30;
        _arrowColor = Colors.white;
        break;
      case 2:
        _backgroundColor = Color(0xFFB1E4155);
        _headingColor = Colors.white;
        _loginYOffset = 200;
        _registerYOffset = 0;
        _headingTop = 30;
        _arrowColor = Colors.white;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            color: _backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: SafeArea(
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: _arrowColor,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (_pageState == 2) {
                              _pageState = 1;
                            } else {
                              _pageState = 0;
                            }
                          });
                        },
                      ),
                      AnimatedContainer(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: Duration(milliseconds: 1000),
                        margin: EdgeInsets.only(top: _headingTop),
                        child: Text(
                          "Lots ToDo",
                          style: TextStyle(
                            color: _headingColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Welcome, we are so glad to see you!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _headingColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Image.asset(
                          'assets/images/getStarted.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 32),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (_pageState != 0) {
                              _pageState = 0;
                            } else {
                              _pageState = 1;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Login Section
          Form(
            key: loginFormKey,
            child: AnimatedContainer(
              padding: EdgeInsets.all(32),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform: Matrix4.translationValues(0, _loginYOffset, 1),
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Login To Continue",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF1D1D1D),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      InputWithIcon(
                        btnIcon: Icons.email_outlined,
                        hintText: "Email",
                        myController: emailController,
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
                        height: 20,
                      ),
                      InputWithIcon(
                        btnIcon: Icons.vpn_key,
                        hintText: "Password",
                        myController: passwordController,
                        obscure: true,
                        validateFunc: (value) {
                          if (forgetPassClick) {
                            return null;
                          } else if (value.isEmpty) {
                            return "Enter Password";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 characters!";
                          }
                          return null;
                        },
                      ),
                      TextButton(
                        child: Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            forgetPassClick = true;
                          });
                          loginFormKey.currentState.validate();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                          btnText: "Login",
                          onPressed: () {
                            print(":::::::::::::LOGIN:::::::::::::::");
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                        btnText: "Continue with Google",
                        onPressed: () {
                          // Signing the User with Google
                          print(":::::::::::::::GOOGLE_SIGNIN::::::::::::::::");
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        child: OutlineBtn(
                          btnText: "Create New Account",
                        ),
                        onTap: () {
                          setState(() {
                            _pageState = 2;
                            emailController.clear();
                            passwordController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SignUp Section
          Form(
            key: signUpFormKey,
            child: AnimatedContainer(
                padding: EdgeInsets.all(32),
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 1000),
                transform: Matrix4.translationValues(0, _registerYOffset, 1),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                          child: Text(
                            "Create a New Account",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.phone,
                      hintText: "Phone",
                      myController: phoneController,
                      keyboardType: TextInputType.phone,
                      validateFunc: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return 'Phone Required';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.email_outlined,
                      hintText: "Email",
                      myController: emailController,
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
                      height: 20,
                    ),
                    InputWithIcon(
                      btnIcon: Icons.vpn_key,
                      hintText: "Password",
                      obscure: true,
                      myController: passwordController,
                      validateFunc: (value) {
                        if (value.isEmpty) {
                          return "Enter Password";
                        } else if (value.length < 6) {
                          return "Password should be atleast 6 characters!";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputWithIcon(
                        btnIcon: Icons.vpn_key,
                        hintText: "Confirm Password",
                        obscure: true,
                        myController: confirmPassController,
                        validateFunc: (val) {
                          if (val.isEmpty) return 'Empty';
                          if (val != passwordController.text)
                            return 'Not Match';
                          if (val.isEmpty) return 'Enter Password';
                          if (val != passwordController.text)
                            return 'Not Match';
                          return null;
                        }),
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      child: PrimaryButton(
                        btnText: "Create Account",
                      ),
                      onTap: () {
                        print(":::::::::::::SIGNUP:::::::::::::::");
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 1;
                          emailController.clear();
                          passwordController.clear();
                        });
                      },
                      child: OutlineBtn(
                        btnText: "Have an account?",
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }

  // Checking Submission from the login Form
  bool loginAndValidate() {
    final form = loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // Checking Submission from the login Form
  bool signUpAndValidate() {
    final form = signUpFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

class PrimaryButton extends StatefulWidget {
  final String btnText;
  PrimaryButton({this.btnText, this.onPressed});
  final void Function() onPressed;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1D1D1D),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(15),
        child: Center(
            child: Text(
          widget.btnText,
          style: TextStyle(color: Colors.white, fontSize: 16),
        )),
      ),
    );
  }
}

class OutlineBtn extends StatefulWidget {
  final String btnText;
  OutlineBtn({this.btnText});

  @override
  _OutlineBtnState createState() => _OutlineBtnState();
}

class _OutlineBtnState extends State<OutlineBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFB1E4155),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(50)),
      padding: EdgeInsets.all(15),
      child: Center(
          child: Text(
        widget.btnText,
        style: TextStyle(color: Color(0xFFB1E4155), fontSize: 16),
      )),
    );
  }
}
