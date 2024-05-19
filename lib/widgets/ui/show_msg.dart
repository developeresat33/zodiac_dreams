import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMsg {
  static showMsg(String? title, {option = 0, bool isShorDuration = false}) {
    switch (option) {
      case 0:
        CherryToast.warning(
          inheritThemeColors: true,
          title: Text('$title'),
          borderRadius: 10,
        ).show(Get.context!);
        break;

      case 1:
        CherryToast.success(
          inheritThemeColors: true,
          title: Text('$title'),
          borderRadius: 10,
        ).show(Get.context!);
        break;

      default:
        break;
    }
  }
}
