import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class CheckNotificationPermission {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  late NotificationSettings settings;
  StreamSubscription? sceneListener;
  static CheckNotificationPermission? _instance;

  static CheckNotificationPermission get instance {
    _instance ??= CheckNotificationPermission._init();
    return _instance!;
  }

  CheckNotificationPermission._init();

  Future<bool> checkPermission() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<bool> checkPermissionWithObserver() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      sceneListener?.cancel();
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }
}
