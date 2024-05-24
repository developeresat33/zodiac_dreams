import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingHelper {
  static Future<void> initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      inspect(message);

      if (message.notification != null) {
        showNotification(message.notification, message.data['isExpert']);
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static Future<void> showNotification(
      RemoteNotification? notification, bool? isExpert) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, notification!.title, notification.body, platformChannelSpecifics,
        payload: isExpert.toString());
  }

  
}
