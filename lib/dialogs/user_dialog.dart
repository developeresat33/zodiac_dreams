import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/screens/select_horoscope.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class UserDialog {
  static void horoscopeModelBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context!,
        useSafeArea: true,
        builder: (context) {
          return Consumer<UserProvider>(
              builder: (context, _value, child) =>
                  StatefulBuilder(builder: (context, setState) {
                    return Container(
                        color: Color.fromRGBO(34, 40, 49, 1),
                        height: Functions.screenSize.height * 0.99,
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            15.h,
                            Row(
                              children: [
                                10.w,
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(
                                      Icons.chevron_left_rounded,
                                      size: 40,
                                    )),
                                10.w,
                                Text("Lütfen burcunuzu seçiniz ; ")
                              ],
                            ),
                            Expanded(child: SelectHoroscope()),
                          ],
                        ));
                  }));
        }).then((value) => Get.focusScope!.unfocus());
  }
}
