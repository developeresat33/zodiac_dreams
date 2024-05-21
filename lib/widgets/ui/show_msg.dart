import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetMsg {
  static showMsg(String? title, {option = 0, bool isShorDuration = false}) {
    switch (option) {
      case 0:
        CherryToast.warning(
          toastPosition: Position.bottom,
          inheritThemeColors: true,
          title: Text('$title'),
          borderRadius: 10,
        ).show(Get.context!);
        break;

      case 1:
        CherryToast.success(
          toastPosition: Position.bottom,
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
