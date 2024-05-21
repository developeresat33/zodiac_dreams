import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:zodiac_star/controller/register_controller.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  RegisterController? registerController = RegisterController();
  UserModel? registerModel, userModel;
  TextEditingController? nickCt = TextEditingController();
  TextEditingController? passwordCt = TextEditingController();
  final webScraper = WebScraper('https://www.haberler.com');

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
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      registerModel!.fcmToken = fcmToken;

      await createUserInFirebase(registerModel!);
      await MongoDatabase.userCollection.save(registerModel!.toJson());

      GetMsg.showMsg("Kayıt başarıyla tamamlandı.", option: 1);
      userModel = registerModel;
      onLoading(true);
      Get.offAll(() => HomePage());
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
        "Kayıt işlemi başarısız lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 1,
      );
    }
  }

  Future<void> createUserInFirebase(UserModel userModel) async {
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection('users').add(userModel.toJson());
  }

  loginUser() async {
    userModel = UserModel();
    onLoading(false);
    await MongoDatabase.userCollection.findOne({
      'nick': nickCt!.text,
      'password': passwordCt!.text,
    }).then((value) {
      if (value != null) {
        /*      inspect(value); // user modeli böyle çek */
        if (value['password'] == passwordCt!.text) {
          onLoading(true);
          userModel = UserModel.parseRegisterModelFromDocument(value);
          log(userModel!.id.toString());
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

 /*  String constructFCMPayload(/* String? token */) {
    return jsonEncode({
      'token':
          "fzTFyQjdSK-TIaPil5j5S2:APA91bG6kVBmfk74R6r-0-k_kDOH_Cq-gCHZd-oxjaOvaVtlqp4bBk7lgWYGJ2nY8d-Q409hA9AAtJg6kANVIS9W6cbhQm_VWMiavHsEHmlgOxzOZrWITjYDxJpRKx3TQNWDjVF86_gX",
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification  was created via FCM!',
      },
    });
  }

  Future<void> sendPushMessage() async {
/*     if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    } */

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  } */
}
