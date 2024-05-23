import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:zodiac_star/controller/register_controller.dart';
import 'package:zodiac_star/data/expert_model.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/main.dart';
import 'package:zodiac_star/screens/expert_home.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/services/storage_manager.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> saveUser() async {
    onLoading(false);

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('nick', isEqualTo: registerModel!.nick)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        onLoading(true);
        GetMsg.showMsg(
          "Bu kullanıcı adı zaten kayıtlı. Lütfen başka bir kullanıcı adı giriniz.",
          option: 0,
        );
        return;
      }

      String? fcmToken = await messaging!.getToken();
      print(fcmToken);
      registerModel!.fcmToken = fcmToken;

      DocumentReference docRef =
          await _firestore.collection('users').add(registerModel!.toJson());

      registerModel!.uid = docRef.id;
      await docRef.update({'uid': docRef.id});

      GetMsg.showMsg("Kayıt başarıyla tamamlandı.", option: 1);

      userModel = registerModel;

      onLoading(true);

      Get.offAll(() => HomePage());
    } catch (e) {
      onLoading(true);

      // Hata mesajı göster
      GetMsg.showMsg(
        "Kayıt işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
  }

  Future<void> saveExpert() async {
    try {
      final data = {
        "expert_username": "asya33",
        "expert_name": "Asya",
        "expert_pw": "asya3.3",
        "fcmToken": "",
        "uid": ""
      };

      DocumentReference docRef =
          await _firestore.collection("expert_account").add(data);

      // UID'yi belgeye ekleyin
      data['uid'] = docRef.id;

      // UID'yi belgeye güncelleyin
      await docRef.update({'uid': docRef.id});

      print('Belge başarıyla eklendi. Document ID: ${docRef.id}');
    } catch (e) {
      print('Belge eklenirken bir hata oluştu: $e');
    }
  }

  Future<void> loginUser() async {
    userModel = UserModel();
    onLoading(false);

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('nick', isEqualTo: nickCt!.text)
          .where('password', isEqualTo: passwordCt!.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        if (userDoc['password'] == passwordCt!.text) {
          String? fcmToken = await messaging!.getToken();

          await _firestore.collection('users').doc(userDoc.id).update({
            'fcmToken': fcmToken,
          });

          userModel = UserModel.parseRegisterModelFromDocument(
              userDoc.data() as Map<String, dynamic>);
          userModel!.fcmToken = fcmToken;

          if (rememberMe!) {
            StorageManager.setString("id", nickCt!.text);
            StorageManager.setString("pw", passwordCt!.text);
            StorageManager.setBool("remind", true);
          }

          isExpert = false;
          onLoading(true);
          Get.offAll(() => HomePage());
        } else {
          onLoading(true);
          GetMsg.showMsg("Hatalı şifre.", option: 0);
        }
      } else {
        onLoading(true);
        GetMsg.showMsg("Kullanıcı bulunamadı.", option: 0);
      }
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
        "Giriş işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
  }

  Future<void> loginExpert() async {
    expertModel = ExpertModel();
    onLoading(false);
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('expert_account')
          .where('expert_username', isEqualTo: expertNickCt!.text)
          .where('expert_pw', isEqualTo: expertPasswordCt!.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot expertDoc = querySnapshot.docs.first;

        if (expertDoc['expert_pw'] == expertPasswordCt!.text) {
          String? fcmToken = await messaging!.getToken();

          await _firestore
              .collection('expert_account')
              .doc(expertDoc.id)
              .update({
            'fcmToken': fcmToken,
          });

          expertModel = ExpertModel.parseRegisterModelFromDocument(
              expertDoc.data() as Map<String, dynamic>);
          expertModel!.fcmToken = fcmToken;

          onLoading(true);
          Get.offAll(() => ExpertHome());
        } else {
          onLoading(true);
          GetMsg.showMsg("Hatalı şifre.", option: 0);
        }
      } else {
        onLoading(true);
        GetMsg.showMsg("Kullanıcı bulunamadı.", option: 0);
      }
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
        "Giriş işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
  }

  Future<void> addFavoriteDream(String dreamTitle) async {
    onLoading(false);

    try {
      await _firestore
          .collection('users')
          .doc(userModel!.uid)
          .collection(FirebaseConstant.favDreamCollection)
          .add({
        'user_uid': userModel!.uid,
        'dream_title': dreamTitle,
      });

      GetMsg.showMsg("Favori rüya başarıyla eklendi.", option: 1);

      onLoading(true);
    } catch (e) {
      onLoading(true);

      GetMsg.showMsg(
        "Favori rüya ekleme işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
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
}
