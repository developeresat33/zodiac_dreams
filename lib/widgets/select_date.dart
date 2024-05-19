import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/states/user_provider.dart';

final DateFormat formatter = DateFormat('dd.MM.yyyy');
void selectDate(
  TextEditingController controller, {
  int? option,
  bool isInitProp = false,
  String? initDate,
}) async {
  DateTime? picked;
  String? date;
  picked = await showDatePicker(
      context: Get.context!,
      initialDate: isInitProp ? formatter.parse(initDate!) : DateTime.now(),
      locale: const Locale("tr", "TR"),
      firstDate: DateTime(1999),
      lastDate: DateTime(2050));

  if (picked != null) {
    date = formatter.format(picked);
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
