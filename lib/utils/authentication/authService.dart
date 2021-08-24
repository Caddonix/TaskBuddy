import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:taskbuddy/utils/authentication/user.dart';

class AuthService {
  /// Returns an object of custom User class by taking [response]
  User _user(Map<String, dynamic> response) {
    return User.fromJson(response);
  }

  /// Creates a new user
  Future<User?> registerUser(
      String email, String password, String name, String userName) async {
    try {
      // Request signup action from server
      final response = await http.post(
        Uri.parse('http://task-buddies.herokuapp.com/user/register'),
        body: {
          // Sending the user data to the server
          "email": email,
          "password": password,
          "name": name,
          "alias": userName,
        },
      );
      print("Signup::: ${response.body}");
      if (response.statusCode == 200) {
        var loggedInUser = await loginUser(email, password);
        Fluttertoast.showToast(msg: "Login Successful!");
        return loggedInUser;
      } else {
        final errorObject = jsonDecode(response.body);
        Fluttertoast.showToast(msg: errorObject["error"]);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Something went wrong. Try again in Login!");
    }
  }

  /// Login the user
  ///
  /// Stored fields in [SharedPreferences] Provider:
  ///
  /// email, name, alias(username), and JWT token
  Future<User?> loginUser(String email, String password) async {
    // Request login action from server
    try {
      final response = await http.post(
        Uri.parse('http://task-buddies.herokuapp.com/user/login'),
        body: {
          // Sending the user data to the server
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return _user(res);
      } else {
        final errorObject = jsonDecode(response.body);
        Fluttertoast.showToast(msg: errorObject["error"]);
        return null;
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: "Check your email and password!");
      return null;
    }
  }
}
