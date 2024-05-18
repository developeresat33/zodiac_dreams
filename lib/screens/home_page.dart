import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:zodiac_dreams/data/menu_items.dart';
import 'package:zodiac_dreams/screens/main_page.dart';
import 'package:zodiac_dreams/states/home_page_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, HomePageProvider _, child) => SafeArea(
              child: Scaffold(
                  bottomNavigationBar: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                      hintColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: SalomonBottomBar(
                            onTap: (value) => _.onItemTapped(value),
                            currentIndex: _.currentIndex,
                            selectedItemColor: Colors.blue[300],
                            items: MenuItems.bottomMenuList)
                        .paddingAll(10),
                  ).paddingAll(10),
                  body: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _.pageController,
                    children: [
                      MainPage(),
                      Container(),
                      Container(),
                    ],
                  )),
            ));
  }
}
