import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskbuddy/utils/authentication/user.dart';

class API {
  /// Returns an object of custom User class by taking [response]
  User _user(Map<String, dynamic> response) {
    return User.fromJson(response);
  }

  User _pairedUser(Map<String, dynamic> response) {
    return User.pairedUser(response);
  }

  Future<http.Response> getRequest(String url, SharedPreferences prefs) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${prefs.getString('token')}",
      },
    );
    return response;
  }

  Future<http.Response> postRequest(String url, {dynamic body, required SharedPreferences prefs}) async {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {"Authorization": "Bearer ${prefs.getString('token')}", "Content-Type": "application/json"},
    );
    return response;
  }

  /// Pass the updated ToDoList to send it to server for storage
  Future<bool> updateToDoList({required SharedPreferences prefs, required List<Map<String, dynamic>> updatedList}) async {
    final response = await postRequest(
      "http://task-buddies.herokuapp.com/user/savetodo",
      prefs: prefs,
      body: updatedList,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      Fluttertoast.showToast(msg: "Cannot fetch ToDos! Check your internet connectivity.");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchToDos({required SharedPreferences prefs}) async {
    try {
      final response = await getRequest("http://task-buddies.herokuapp.com/user/gettodo", prefs);
      if (response.statusCode == 200) {
        if (response.body == '{"error":"No Todos stored"}') {
          return [];
        } else {
          final List<Map<String, dynamic>> todos = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          return todos;
        }
      } else
        return null;
    } catch (error) {
      print(error);
      Fluttertoast.showToast(msg: "Something went wrong!");
      return null;
    }
  }

  Future<List<String>> fetchCategories({required SharedPreferences prefs}) async {
    try {
      final response = await getRequest("http://task-buddies.herokuapp.com/user/getcategories", prefs);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var categories = (json as List).map((e) => e as String).toList();
        return categories;
      } else {
        Fluttertoast.showToast(msg: "Cannot fetch Categories! Check your internet connectivity.");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  /// Returns the data about the currently logged in user
  Future<User?> currentUser({required SharedPreferences prefs}) async {
    final response = await getRequest("http://task-buddies.herokuapp.com/user/currentUser", prefs);

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = jsonDecode(response.body);
      return _user(user);
    } else {
      final errorObject = jsonDecode(response.body);
      Fluttertoast.showToast(msg: errorObject["error"]);
    }
  }

  /// Returns the [User] object containing the data about the paired user
  Future<User?> pairedUser({required SharedPreferences prefs}) async {
    final response = await postRequest("http://task-buddies.herokuapp.com/user/dummypair", prefs: prefs);
    print("Response ${response.body}");
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> user = jsonDecode(response.body);
        return _pairedUser(user["paired"]);
      } else {
        final errorObject = jsonDecode(response.body);
        Fluttertoast.showToast(msg: errorObject["error"] ?? "Connection not found. Check your internet!");
        return null;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Connection not found. Check your internet!");
      return null;
    }
  }

  /// Logout the user and clear the [SharedPreferences] stored for a  user
  Future<bool> logoutUser({required SharedPreferences prefs}) async {
    // Request logout action from server
    try {
      final response = await getRequest('http://task-buddies.herokuapp.com/user/logout', prefs);
      if (response.statusCode == 200) {
        await prefs.clear();
        Fluttertoast.showToast(msg: "Logout Successful");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Something went wrong. Still logged in!");
        return false;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Something went wrong. Still logged in!");
      return false;
    }
  }
}
