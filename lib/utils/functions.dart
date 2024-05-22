import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class Functions {
  static Size screenSize = MediaQuery.of(Get.context!).size;
  static final NumberFormat formatterPrice = NumberFormat.currency(
    customPattern: '#,##0.00 ₺',
    locale: 'tr_TR',
    symbol: "",
  );
}
