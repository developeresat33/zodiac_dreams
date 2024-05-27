import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:zodiac_star/controller/register_controller.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dbHelper/auth.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/main.dart';
import 'package:zodiac_star/screens/expert_home.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/services/firebase_message.dart';
import 'package:zodiac_star/services/storage_manager.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class UserProvider extends ChangeNotifier {
  FirebaseAuthService authService = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool? rememberMe = false;
  RegisterController? registerController = RegisterController();
  UserModel? registerModel, userModel;

  TextEditingController? emailCt = TextEditingController();
  TextEditingController? passwordCt = TextEditingController();
  TextEditingController? expertEmailCt = TextEditingController();
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
      User? firebaseUser = await authService.registerWithEmailAndPassword(
          registerModel!.email!, registerModel!.password!);

      // Kullanıcı kaydını kontrol et
      QuerySnapshot querySnapshot = await _firestore
          .collection(FirebaseConstant.userCollection)
          .where('email', isEqualTo: registerModel!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        onLoading(true);
        GetMsg.showMsg(
          "Bu kullanıcı e-posta zaten kayıtlı. Lütfen başka bir email giriniz.",
          option: 0,
        );
        return;
      }

      // FCM tokeni al
      String? fcmToken = await FirebaseMessagingHelper.messaging!.getToken();
      registerModel!.fcmToken = fcmToken;

      // Kullanıcı verisini Firestore'a kaydet
      DocumentReference docRef =
          _firestore.collection('users').doc(firebaseUser!.uid);
      registerModel!.uid = firebaseUser.uid;
      await docRef.set(registerModel!.toJson());

      GetMsg.showMsg("Kayıt başarıyla tamamlandı.", option: 1);

      userModel = registerModel;

      onLoading(true);
      Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      onLoading(true);
      if (e.code == 'email-already-in-use') {
        GetMsg.showMsg(
          "Bu e-posta adresi zaten kayıtlı. Lütfen başka bir e-posta adresi deneyiniz.",
          option: 0,
        );
      } else {
        GetMsg.showMsg(
          "Kayıt işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.message}",
          option: 0,
        );
      }
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
        "Kayıt işlemi başarısız, lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
        option: 0,
      );
    }
  }

  Future<void> loginUser() async {
    onLoading(false);
    userModel = UserModel();

    try {
      User? firebaseUser = await authService.signInWithEmailAndPassword(
        emailCt!.text,
        passwordCt!.text,
      );

      if (firebaseUser != null) {
        DocumentSnapshot? userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        userModel = UserModel.parseRegisterModelFromDocument(
            userDoc.data() as Map<String, dynamic>);
        if (userDoc.exists) {
          String? getToken =
              await FirebaseMessagingHelper.messaging!.getToken();

          await _firestore
              .collection(FirebaseConstant.userCollection)
              .doc(userDoc.id)
              .update({
            'fcmToken': getToken,
          });

          userModel!.fcmToken = getToken;

          if (isRemind == true) {
            StorageManager.setString("id", emailCt!.text);
            StorageManager.setString("pw", passwordCt!.text);
            StorageManager.setBool("remind", true);
          }

          onLoading(true);

          if (userModel!.isExpert) {
            Get.offAll(() => ExpertHome());
          } else {
            Get.offAll(() => HomePage());
          }
        } else {
          onLoading(true);
          GetMsg.showMsg(
              "Kullanıcı belgesi bulunamadı. Hatalı e-posta veya şifre",
              option: 0);
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
          .collection(FirebaseConstant.userCollection)
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
