import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class FirebaseMessagingHelper {
  static Future<void> initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      GetMsg.showMsg('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Diğer callback fonksiyonları buraya eklenebilir
  }
}
