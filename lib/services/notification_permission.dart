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
/*         sceneListener ??=
            LifeCycleObserver().lifeCycleObserver.listen((value) async {
          if (value == AppLifecycleState.resumed) {
            bool value = await Permission.notification.isGranted;
            if (value == true) {
              sceneListener?.cancel();
              Get.close(1);
            }
          }
        });
        DialogService.instance.showCustomDialog(
            "user.notification.content".translateMap(),
            isSuccess: false,
            dismissible: false,
            alignment: Alignment.topCenter,
            secondButtonText: "user.common.btn_settings".translateMap(),
            secondButton: () {
          AppSettings.openAppSettings(type: AppSettingsType.notification,asAnotherTask: true)
              .then((value) {
          });
        }); */
      return Future<bool>.value(false);
    }
  }
}
