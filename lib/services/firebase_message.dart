import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingHelper {
  static FirebaseMessaging? messaging;
  static Future<void> initFirebaseMessaging() async {
    messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      inspect(message);

      if (message.notification != null) {
        showNotification(message.notification, message.data['isExpert']);
        print('Message also contained a notification: ${message.notification}');
      }
    });

    NotificationSettings permission = await messaging!.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (permission.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
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

  static void sendNotification(
    String? title,
    String? body,
    String? token,
  ) async {
    http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode({
          "to": token,
          "content_available": true,
          "apns-priority": "5",
          "notification": {"title": title, "body": body, "sound": "none"},
          /*        "data": {"isExpert": isExpert}, */
          "android": {"priority": "height", "ttl": "110"},
          "apns": {
            "headers": {"apns-priority": "5"}
          },
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization":
              "key=AAAAi5dUN7k:APA91bHu484HSosEfcIOUI00SOtBqV8usvqxS7hEruPnTad-Zb1p996iX3wV9ecDjGX6_YurZyXiFRWvsDL0vSe1tBcOouVDWz77M7W_2w8oHSQ2Lu6gPHYxDOctIDAkHvvcJg11eX9o"
        });
  }
}
