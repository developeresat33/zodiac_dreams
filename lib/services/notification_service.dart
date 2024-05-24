import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zodiac_star/services/storage_manager.dart';
import 'package:http/http.dart' as http;

class CloudNotificationService {
  static CloudNotificationService? _cloudNotificationServiceInitialize;
  static FirebaseMessaging? _firebaseMessaging;
  /* final NotificationService localService = NotificationService.instance; */

  static CloudNotificationService get cloudNotificationServiceInitialize {
    if (_cloudNotificationServiceInitialize == null) {
      _firebaseMessaging = FirebaseMessaging.instance;
      return _cloudNotificationServiceInitialize ??= CloudNotificationService();
    } else {
      return _cloudNotificationServiceInitialize!;
    }
  }

  CloudNotificationService() {
    cloudMessagingInitVoid();
  }

  cloudMessagingInitVoid() async {
    _firebaseMessaging?.app.setAutomaticResourceManagementEnabled(true);
    _setupInteractedMessage(); //for terminated state tap notification
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    onMessageListenFirebase();

    ///background on tap interection
  }

  _setupInteractedMessage() {
    // Get any messages which caused the application to open from
    // a terminated state.
    _firebaseMessaging?.getInitialMessage().then((initialMessage) {
      debugPrint("---firebaseMessaging?.getInitialMessage()---");
      if (initialMessage?.messageId !=
          StorageManager.getString("notificationID")) {
        if (initialMessage != null) {
          debugPrint(initialMessage.data.toString());
          _handleMessage(initialMessage);
        }
      }
    });
  }

  void onMessageListenFirebase() {
    debugPrint("?? Firenase Messagin onMessageListen function ??");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("On message Listen from Notification Service");
      //final CustomNotificationModel notificationModel = CustomNotificationModel.fromJson(message.data);
      //final String? iosCategoryID = message.category;
      //final String? iosThreadID = message.threadId;
      //final String? androidChannelID = message.notification?.android?.channelId;
      //RemoteNotification? notification = message.notification;
      //AndroidNotification? android = message.notification?.android;
      //notificationModel.channelId! gelen bildirimleri channel id'lerine göre gösterilebilir
      //debugPrint(notificationModel.toJson().toString());
      if (message.notification != null &&
          (message.notification!.title ?? "").isNotEmpty) {
/*         localService.showBigTextNotification(
          notificationID: message.notification.hashCode,
          title: message.notification!.title!,
          body: message.notification!.body??"",
        ); */
      }
    });
  }

  _handleMessage(RemoteMessage? message) async {
    if (message != null) {
      debugPrint("ahhhhhhhhh-------${message.messageId}");
      debugPrint("ahhhhhhhhh-------${message.data}");
      StorageManager.setString("notificationID", message.messageId!);
/*       if (message.data["channel-id"] == NotificationChannelID.general.channelID) {   // bildirimden sonra yönlendirme
        final value = await GetIt.instance<UserProfileProvider>().authCompleter.future;
       if(value) {
         Get.to(
              () => const NotificationsPage(),
          routeName: "/NotificationsPage",
        );
       }
      } */
    }
  }

  static void sendNotification(
      String? title, String? body, String? token, bool? isExpert) async {
    http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode({
          "to": token,
          "content_available": true,
          "apns-priority": "5",
          "notification": {"title": title, "body": body, "sound": "none"},
          "data": {"isExpert": isExpert},
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
