import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialize
  Future initialize() async {
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("taskbuddy_logo");

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
<<<<<<< HEAD
            (int id, String? title, String? body, String? payload) async {});
=======
            (int id, String title, String body, String payload) async {});
>>>>>>> b0fff4efcd44fa3624aa3f1aff42a045df17ab2b

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
<<<<<<< HEAD
        onSelectNotification: (String? payload) async {
=======
        onSelectNotification: (String payload) async {
>>>>>>> b0fff4efcd44fa3624aa3f1aff42a045df17ab2b
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  // Instant Notification
  Future instantNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     "alarm_notif", "alarm_notif", "Channel for alarm notification",
    //     icon: "taskbuddy_logo",
    //     sound: RawResourceAndroidNotificationSound("alarm_notification_audio"),
    //     largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"));

    var iOS = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: iOS);

    await _flutterLocalNotificationsPlugin.show(
<<<<<<< HEAD
      0,
      "Hello world!",
      "Tap me please baby!",
      platform,
      payload: "How you doin!",
    );
=======
        0, "Hello world!", "Tap me please baby!", platform,
        payload: "How you doin!");
>>>>>>> b0fff4efcd44fa3624aa3f1aff42a045df17ab2b
  }

  // Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("taskbuddy_logo"),
        largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
        contentTitle: "Hello World!",
        summaryText: "Tap me baby! ;)",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.show(
        0, "Hello world Image!", "Tap me please baby!", platform,
        payload: "How you doin!");
  }

  // Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails(
<<<<<<< HEAD
      "id",
      "channel",
      "description",
      color: Colors.deepPurple,
      enableLights: true,
      enableVibration: true,
      largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
      styleInformation:
          MediaStyleInformation(htmlFormatContent: true, htmlFormatTitle: true),
=======
        "id",
        "channel",
        "description",
    color: Colors.deepPurple,
      enableLights: true,
      enableVibration: true,
      largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
      styleInformation: MediaStyleInformation(htmlFormatContent: true, htmlFormatTitle: true),
>>>>>>> b0fff4efcd44fa3624aa3f1aff42a045df17ab2b
    );

    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.show(
        0, "Hello world Stylish!", "Tap me please baby!", platform);
  }

  // Scheduled Notification
  Future scheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("taskbuddy_logo"),
        largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
        contentTitle: "Hello World!",
        summaryText: "Tap me baby! ;)",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
<<<<<<< HEAD
        0, "Hello world Scheduled!", "Tap me please baby!", interval, platform);
=======
        0, "Hello world Scheduled!", "Tap me please baby!", interval ,platform);
>>>>>>> b0fff4efcd44fa3624aa3f1aff42a045df17ab2b
  }

  // Cancel notifications
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
