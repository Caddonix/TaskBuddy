import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final SharedPreferences prefs = Provider.of<SharedPreferences>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              // Account Tile
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.white.withOpacity(0.7),
                ),
                title: Text("Logout", style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  "Logout from the session",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) => AlertDialog(
                      title: Text(
                        'Confirm Logout',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Are you sure you want to logout?"),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            setState(() {
                              _isLoading = true;
                            });
                            API api = Provider.of<API>(context, listen: false);
                            bool success = await api.logoutUser(prefs: prefs);
                            if (success) {
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Help Tile
              ListTile(
                leading: Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white.withOpacity(0.7),
                ),
                title: Text("Help", style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  "Help center, contact us, privacy policy",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                onTap: () {},
              )
            ],
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
    );
  }
}
