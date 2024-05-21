import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class AppBarWidget {
  static AppBar getAppBar(title,
      {bool isAction = false,
      Widget? action,
      bool isBottom = false,
      PreferredSizeWidget? bottomWidget,
      Widget? leading,
      var function}) {
    return AppBar(
      backgroundColor: Color.fromRGBO(34, 40, 49, 1),
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0), // Alt sınırın yüksekliği
        child: Container(
          color: Colors.grey, // Alt sınırın rengi
          height: 0.2, // Alt sınırın kalınlığı
        ),
      ),
      actions: isAction
          ? [
              Container(
                width: Functions.screenSize.width * 0.5,
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      action!,
                      10.w,
                    ],
                  ),
                ),
              ),
            ]
          : [],
      title: Container(
        alignment: Alignment.centerLeft,
        width: double.maxFinite,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
          ),
        ),
      ),
      leading: leading ??
          IconButton(
              onPressed: () {
                Get.back();
                function ?? null;
              },
              icon: Icon(Icons.chevron_left)),
    );
  }
}
