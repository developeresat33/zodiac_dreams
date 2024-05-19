import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        15.h,
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Hoşgeldiniz , ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Huzurlu bir gün geçirmeniz dileği ile ..  ",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                height: 75,
                width: 75,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
        15.h,
        Expanded(
          child: ListView(
            children: [
              CardTile(
                onTap: () => print("sdsd"),
                leading: FontAwesomeIcons.wandMagicSparkles,
                title: "Bir uzman'dan tabir yorumu al",
                desp:
                    "Rüyanızı uzman rüya tabircilerimize yorumlatmak için tıklayınız..",
                trailing: Icons.chevron_right_outlined,
              ),
              10.h,
              Divider(
                thickness: 0.5,
              )
            ],
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 20);
  }
}
