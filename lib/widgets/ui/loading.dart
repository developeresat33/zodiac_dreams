import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/utils/int_extension.dart';

bool isLoadingDialog = false;

void onLoading(bool isOk) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (isOk == false) {
      isLoadingDialog = true;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 35,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SpinKitFadingFour(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  40.w,
                  new Text("Yükleniyor"),
                  20.w
                ],
              ),
            ),
          );
        },
      );
    }
  });
  if (isOk == true) {
    isLoadingDialog = false;
    Get.back();
    Get.focusScope?.unfocus();
  }
}

Widget getLoading() {
  return SizedBox(
    height: 35,
    width: 35,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: SpinKitFadingFour(
        color: Colors.white70,
      ),
    ),
  );
}
