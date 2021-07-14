import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:taskbuddy/utils/authentication/user.dart';

class AuthService {
  /// Returns an object of custom User class by taking [response]
  User _user(Map<String, dynamic> response) {
    return User.fromJson(response);
  }

  /// Returns the data about the currently logged in user
  Future<User?> currentUser() async {
    final response = await http
        .get(Uri.parse("http://task-buddies.herokuapp.com/currentUser"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = jsonDecode(response.body);
      return _user(user);
    } else {
      final errorObject = jsonDecode(response.body);
      Fluttertoast.showToast(msg: errorObject["error"]);
    }
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
        Fluttertoast.showToast(msg: "Login Successful!");
        return _user(res);
      } else {
        final errorObject = jsonDecode(response.body);
        Fluttertoast.showToast(msg: errorObject["error"]);
      }
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: "Something went wrong. Try again in Login!");
    }
  }


}