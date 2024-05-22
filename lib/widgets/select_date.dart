import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:zodiac_star/utils/int_extension.dart';

final DateFormat formatter = DateFormat('dd.MM.yyyy');

void selectDate(
  TextEditingController controller, {
  int? option,
  bool isInitProp = false,
  String? initDate,
}) async {
  DateTime? picked;
  String? date;
  picked = await showCupertinoModalPopup<DateTime>(
    context: Get.context!,
    builder: (BuildContext context) {
      return SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(34, 40, 49, 1),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime:
                    isInitProp ? formatter.parse(initDate!) : DateTime.now(),
                minimumYear: 1950,
                maximumYear: 2090,
                onDateTimeChanged: (DateTime newDate) {
                  picked = newDate;
                },
              ),
            ),
            100.h,
            ZodiacButton(
              size: Size(double.maxFinite, 50),
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop(picked);
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
      );
    },
  );

  // Yorum: CupertinoDatePicker'dan bir tarih seçildiğinde
  // seçilen tarih metin denetleyicisine yazdırılır.
  if (picked != null) {
    date = formatter.format(picked!);
    controller.text = date;
  }

  switch (option) {
    case 0:
      var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
      userprop.registerModel!.birthDate = date;
      break;
    default:
      break;
  }
}
