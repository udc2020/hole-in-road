import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifocationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init() async {
    AwesomeNotifications().initialize('', [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'basic notification',
          channelDescription: 'somthing',
          importance: NotificationImportance.High,
          channelShowBadge: true)
    ]);
  }

  static Future _notificationDetail() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(id, title, body, await _notificationDetail(),
          payload: payload);

  static Future detecteHole(String address, double? distence) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 0,
          channelKey: 'basic_channel',
          title: 'hole Near You',
          body: '$address is near you now ${distence ?? 0}KM',
          backgroundColor: const Color.fromARGB(0, 12, 0, 3)),
      schedule: NotificationInterval(repeats: false, interval: 1),
    );
  }

  static Future stop() async {
    await AwesomeNotifications().cancelAll();
  }
}
