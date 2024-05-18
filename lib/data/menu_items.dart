import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MenuItems {
  static final List<SalomonBottomBarItem> bottomMenuList = [
    SalomonBottomBarItem(
        icon: Icon(
          Icons.tablet_android,
        ),
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Anasayfa"))),
    SalomonBottomBarItem(
        icon: Icon(
          Icons.text_rotate_vertical_outlined,
        ),
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Tabirler"))),
    SalomonBottomBarItem(
        icon: Icon(
          Icons.card_giftcard,
        ),
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Söz Kartları"))),
    SalomonBottomBarItem(
        icon: Icon(
          Icons.edit_note_sharp,
        ),
        title: FittedBox(fit: BoxFit.scaleDown, child: Text("Tabir Yorumlat"))),
  ];

  static final List<HoroscopeItem> horoscopeList = [
    HoroscopeItem(
      name: 'Koç',
      subtitle: '21 Mart - 20 Nisan',
      color: Colors.redAccent,
      image: "assets/horoscope/koc.png",
    ),
    HoroscopeItem(
      name: 'Boğa',
      subtitle: '21 Nisan - 21 Mayıs',
      color: Colors.green[600],
      image: "assets/horoscope/boga.png",
    ),
    HoroscopeItem(
      name: 'İkizler',
      subtitle: '22 Mayıs - 21 Haziran',
      color: Colors.purple,
      image: "assets/horoscope/ikizler.png",
    ),
    HoroscopeItem(
      name: 'Yengeç',
      subtitle: '22 Haziran - 22 Temmuz',
      color: Colors.blue,
      image: "assets/horoscope/yengec.png",
    ),
    HoroscopeItem(
      name: 'Aslan',
      subtitle: '23 Temmuz - 22 Ağustos',
      color: Colors.orange,
      image: "assets/horoscope/aslan.png",
    ),
    HoroscopeItem(
      name: 'Başak',
      subtitle: '23 Ağustos - 22 Eylül',
      color: Colors.green,
      image: "assets/horoscope/basak.png",
    ),
    HoroscopeItem(
      name: 'Terazi',
      subtitle: '23 Eylül - 22 Ekim',
      color: Colors.deepPurpleAccent,
      image: "assets/horoscope/terazi.png",
    ),
    HoroscopeItem(
      name: 'Akrep',
      subtitle: '23 Ekim - 21 Kasım',
      color: Colors.blueGrey,
      image: "assets/horoscope/akrep.png",
    ),
    HoroscopeItem(
      name: 'Yay',
      subtitle: '22 Kasım - 21 Aralık',
      color: Colors.deepOrangeAccent,
      image: "assets/horoscope/yay.png",
    ),
    HoroscopeItem(
        name: 'Oğlak',
        subtitle: '22 Aralık - 21 Ocak',
        image: "assets/horoscope/oglak.png",
        color: Colors.blueGrey[600]),
    HoroscopeItem(
      name: 'Kova',
      subtitle: '22 Ocak - 19 Şubat',
      color: Colors.pinkAccent,
      image: "assets/horoscope/kova.png",
    ),
    HoroscopeItem(
      name: 'Balık',
      subtitle: '20 Şubat - 20 Mart',
      color: Colors.lightBlue,
      image: "assets/horoscope/balık.png",
    ),
  ];
}

class HoroscopeItem {
  String? name;
  String? subtitle;
  Color? color;
  String? image;
  HoroscopeItem({this.name, this.subtitle, this.color, this.image});
}
