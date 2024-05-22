import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:zodiac_star/controller/register_controller.dart';
import 'package:zodiac_star/data/expert_model.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';
import 'package:zodiac_star/main.dart';
import 'package:zodiac_star/screens/expert_home.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/services/storage_manager.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  bool? rememberMe = false;
  RegisterController? registerController = RegisterController();
  UserModel? registerModel, userModel;
  ExpertModel? expertModel;
  TextEditingController? nickCt = TextEditingController();
  TextEditingController? passwordCt = TextEditingController();
  TextEditingController? expertNickCt = TextEditingController();
  TextEditingController? expertPasswordCt = TextEditingController();
  final webScraper = WebScraper('https://www.haberler.com');

  setRemindMe(bool? value) {
    rememberMe = value;
    notifyListeners();
  }

  String transformString(String input) {
    if (input.isEmpty) return input;
    String result = input[0].toLowerCase() + input.substring(1);

    const turkishToEnglish = {
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
      'Ç': 'c',
      'Ğ': 'g',
      'I': 'i',
      'İ': 'i',
      'Ö': 'o',
      'Ş': 's',
      'Ü': 'u'
    };

    turkishToEnglish.forEach((turkishChar, englishChar) {
      result = result.replaceAll(turkishChar, englishChar);
    });

    return result;
  }

  void saveUser() async {
    onLoading(false);

    try {
      String? fcmToken = await messaging!.getToken();
      print(fcmToken);
      registerModel!.fcmToken = fcmToken;

      bool userExists = await checkUserExistsInMongoDB(registerModel!.nick!);

      if (userExists) {
        onLoading(true);
        GetMsg.showMsg(
            "Bu kullanıcı zaten kayıtlı.Lütfen başka bir kullanıcı adı giriniz.",
            option: 0);
      } else {
        await MongoDatabase.userCollection.save(registerModel!.toJson());

        GetMsg.showMsg("Kayıt başarıyla tamamlandı.", option: 1);
        userModel = registerModel;
        onLoading(true);
        Get.offAll(() => HomePage());
      }
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
        "Kayıt işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
  }

  Future<bool> checkUserExistsInMongoDB(String nick) async {
    final collection = MongoDatabase.userCollection;

    var query = where.eq('nick', nick);

    var result = await collection.findOne(query);

    return result != null;
  }

  loginUser() async {
    userModel = UserModel();
    onLoading(false);
    await MongoDatabase.userCollection.findOne({
      'nick': nickCt!.text,
      'password': passwordCt!.text,
    }).then((value) async {
      if (value != null) {
        if (value['password'] == passwordCt!.text) {
          String? fcmToken = await messaging!.getToken();

          await MongoDatabase.userCollection.updateOne(
            where.eq('nick', nickCt!.text),
            modify.set('fcmToken', fcmToken),
          );

          onLoading(true);
          userModel = UserModel.parseRegisterModelFromDocument(value);
          userModel!.fcmToken = fcmToken;
          if (rememberMe!) {
            StorageManager.setString("id", nickCt!.text);
            StorageManager.setString("pw", passwordCt!.text);
            StorageManager.setBool("remind", true);
          }
          Get.offAll(() => HomePage());
        } else {
          onLoading(true);
          GetMsg.showMsg("Hatalı sifre.", option: 0);
        }
      } else {
        onLoading(true);
        GetMsg.showMsg("Kullanıcı bulunamadı.", option: 0);
      }
    });
  }

  loginExpert() async {
    expertModel = ExpertModel();
    onLoading(false);
    await MongoDatabase.expertAccountCollection.findOne({
      'expert_username': expertNickCt!.text,
      'expert_pw': expertPasswordCt!.text,
    }).then((value) async {
      inspect(value);
      if (value != null) {
        if (value['expert_pw'] == expertPasswordCt!.text) {
          String? fcmToken = await messaging!.getToken();
          print(fcmToken);
          await MongoDatabase.expertAccountCollection.updateOne(
            where.eq('expert_username', expertNickCt!.text),
            modify.set('fcmToken', fcmToken),
          );

          onLoading(true);
          expertModel = ExpertModel.parseRegisterModelFromDocument(value);
          expertModel!.fcmToken = fcmToken;
          inspect(expertModel);
/*           if (rememberMe!) {
            StorageManager.setString("id", nickCt!.text);
            StorageManager.setString("pw", passwordCt!.text);
            StorageManager.setBool("remind", true);
          } */
          Get.offAll(() => ExpertHome());
        } else {
          onLoading(true);
          GetMsg.showMsg("Hatalı sifre.", option: 0);
        }
      } else {
        onLoading(true);
        GetMsg.showMsg("Kullanıcı bulunamadı.", option: 0);
      }
    });
  }

  saveFavoriteDream() async {
    var result = await MongoDatabase.favCollection.insertOne(
        {'user_id': userModel!.id!, 'text': 'Rüyada beyaz yılan görmek'});
    print(result);
  }

  Future<List<Map<String, dynamic>>> getFavoriteDreams() async {
    return await MongoDatabase.favCollection
        .find(where.eq('user_id', userModel!.id))
        .toList();
  }

  Future<List<Map<String, String>>> fetchData() async {
    List<Map<String, String>> result = [];
    if (await webScraper.loadWebPage(
        '/burclar/${transformString(userModel!.horoscope!)}-burcu/')) {
      List<Map<String, dynamic>> titles =
          webScraper.getElement('div.colPageLeft h3', []);
      List<Map<String, dynamic>> descriptions =
          webScraper.getElement('div.colPageLeft p', []);

      for (int i = 0; i < titles.length; i++) {
        result.add({
          'title': titles[i]['title'] ?? 'No title',
          'description': descriptions.length > i
              ? descriptions[i]['title'] ?? 'No description'
              : 'No description'
        });
      }
    }
    return result;
  }

  sendNotification() async {
    http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        body: jsonEncode({
          "to": "${userModel!.fcmToken}",
          "content_available": true,
          "apns-priority": "5",
          "notification": {
            "title": "Notification Title",
            "body": "body body body body",
            "sound": "none"
          },
          "data": {
            "body": "Sigorta deneme",
            "title": "Title",
            "key_1": "50",
            "key_2": "50",
            "type": "auth",
            "badge": "1"
          },
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
