import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/controller/register_controller.dart';
import 'package:zodiac_star/data/register_model.dart';
import 'package:zodiac_star/dbHelper/mongodb.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class UserProvider extends ChangeNotifier {
  RegisterController? registerController = RegisterController();
  UserModel? registerModel, userModel;

  saveUser() async {
    userModel = UserModel();
    onLoading(false);
    await MongoDatabase.userCollection.save(registerModel!.toJson());
    try {
      GetMsg.showMsg("Kayıt başarıyla tamamlandı.", option: 1);
      userModel = registerModel;
      inspect(userModel);
      onLoading(true);
      Get.offAll(() => HomePage());
    } catch (e) {
      onLoading(true);
      GetMsg.showMsg(
          "Kayıt işlemi başarısız lütfen daha sonra tekrar deneyiniz. ${e.toString()}",
          option: 1);
    }
  }
}
