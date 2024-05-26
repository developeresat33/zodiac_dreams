import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class Functions {
  static Size screenSize = MediaQuery.of(Get.context!).size;
  static final NumberFormat formatterPrice = NumberFormat.currency(
    customPattern: '#,##0.00 ₺',
    locale: 'tr_TR',
    symbol: "₺",
  );

  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

 static DateTime getPSTTime() {
    final turkeyZone = tz.TZDateTime.now(tz.local);
    inspect(turkeyZone);
    return turkeyZone;
  }
}
