import 'package:flutter/material.dart';

class PackageModel {
  String? packageName;
  String? packageDescription;
  String? packagePrice;
  IconData? icon;
  int? packageId;
  PackageModel({
    this.packageName,
    this.packageDescription,
    this.packagePrice,
    this.icon,
    this.packageId,
  });
}
