import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final String _groupKey = 'com.example.TASKBUDDY';
  final String _groupChannelId = 'grouped channel id for Taskbuddy';
  final String _groupChannelName = 'grouped channel name for Taskbuddy';
  final String _groupChannelDescription = 'grouped channel description for Taskbuddy';
  final int _insistentFlag = 4;

  // initialize
  Future initialize() async {
    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("taskbuddy_logo");

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });
  }

  /// Instant Notification
  Future instantNotification({String? title, String? body, String? payload}) async {
    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      sound: RawResourceAndroidNotificationSound("notification_audio"),
      playSound: true,
    );

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  /// Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(DrawableResourceAndroidBitmap("taskbuddy_logo"),
        largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
        contentTitle: "Hello World!",
        summaryText: "Tap me baby! ;)",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      styleInformation: bigPicture,
      sound: RawResourceAndroidNotificationSound("notification_audio"),
      playSound: true,
    );
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.show(0, "Hello world Image!", "Tap me please baby!", platform, payload: "How you doin!");
  }

  /// Stylish Notification
  Future stylishNotification({required int id, String? title, String? body}) async {
    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      color: Colors.deepPurple,
      enableLights: true,
      enableVibration: true,
      largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
      sound: RawResourceAndroidNotificationSound("notification_audio"),
      playSound: true,
      styleInformation: MediaStyleInformation(htmlFormatContent: true, htmlFormatTitle: true),
    );

    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.show(0, "Hello world Stylish!", "Tap me please baby!", platform);
  }

  /// Periodic Notifications
  ///
  /// Periodically show a notification using the specified interval.
  /// For example, specifying a hourly interval means the first time the
  /// notification will be an hour after the method has been called and then every hour after that.
  Future periodicNotification({required int id, String? title, String? body, required RepeatInterval interval}) async {
    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      sound: RawResourceAndroidNotificationSound("notification_audio"),
      playSound: true,
      ticker: 'TaskBuddy ticker',
      additionalFlags: Int32List.fromList(<int>[_insistentFlag]),
    );
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.periodicallyShow(id, title, body, interval, platform);
  }

  /// Scheduled Notifications
  ///
  /// Periodically show a notification using the specified interval.
  /// For example, specifying a hourly interval means the first time the
  /// notification will be an hour after the method has been called and then every hour after that.
  Future scheduledNotification({required int id, String? title, String? body, required DateTime dateTime}) async {
    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      sound: RawResourceAndroidNotificationSound("alarm_notification_audio"),
      largeIcon: DrawableResourceAndroidBitmap("taskbuddy_logo"),
      playSound: true,
      ticker: 'TaskBuddy ticker',
      additionalFlags: Int32List.fromList(<int>[_insistentFlag]),
    );
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      platform,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Scheduled Daily and Timely Notifications
  ///
  /// Periodically show a notification using the specified time daily.
  Future scheduledDailyAndTimelyNotification({required int id, String? title, String? body, required TimeOfDay pickedTime}) async {
    var android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      _groupChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: _groupKey,
      sound: RawResourceAndroidNotificationSound("alarm_notification_audio"),
      playSound: true,
      ticker: 'TaskBuddy ticker',
      additionalFlags: Int32List.fromList(<int>[_insistentFlag]),
    );
    var platform = new NotificationDetails(android: android);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(pickedTime),
      platform,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancels all notifications
  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay _pickedTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, _pickedTime.hour, _pickedTime.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
