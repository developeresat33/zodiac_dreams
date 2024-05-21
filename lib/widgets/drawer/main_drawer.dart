import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/screens/favorite_dreams.dart';
import 'package:zodiac_star/screens/login_page.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _, child) => Drawer(
              backgroundColor: Color.fromRGBO(34, 40, 49, 1),
              child: Column(
                children: [
                  Column(
                    children: [
                      10.h,
                      CardTile(
                        leading: Icons.star,
                        title: "Favori Tabirlerim",
                        onTap: () {
                          Get.to(() => FavoriteDreams());
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 10),
                  Spacer(),
                  Divider(
                    thickness: 0.4,
                  ),
                  ListTile(
                    title: Text("Çıkış Yap"),
                    trailing: Icon(Icons.chevron_right_outlined),
                    onTap: () {
                      Get.offAll(() => LoginPage());
                    },
                  )
                ],
              ),
            ));
  }
}
