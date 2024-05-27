import 'package:flutter/material.dart';
import 'package:zodiac_star/data/package_model.dart';

class MiniItems {
  static List<String> alphabet = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "İ",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "Ö",
    "P",
    "R",
    "S",
    "Ş",
    "T",
    "U",
    "Ü",
    "V",
    "Y",
    "Z"
  ];

  static List<PackageModel> packageItems = [
    PackageModel(
      icon: Icons.drive_file_rename_outline_rounded,
      packageName: "Standart Paket",
      packageDescription:
          "1 Elmas karşılığında uzmanlarımızdan rüya tabiri yorumu alabilirsiniz.",
      packagePrice: "180.00",
      packageId: 1,
    ),
    PackageModel(
      icon: Icons.star_border_purple500_rounded,
      packageName: "Kalp Gözü Paketi",
      packageDescription:
          "2 Elmas karşılığında uzmanlarımızdan Kariyer , Aşk , Sağlık ile ilgili ya da  merak ettiğiniz herhangi bir konu ile ilgili sezgisel öngörü yorumu alabilirsiniz.",
      packagePrice: "300.00",
      packageId: 2,
    )
  ];
}
