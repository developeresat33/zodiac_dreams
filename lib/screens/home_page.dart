import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:zodiac_star/data/menu_items.dart';
import 'package:zodiac_star/screens/expressions.dart';
import 'package:zodiac_star/screens/main_page.dart';
import 'package:zodiac_star/states/home_page_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/drawer/main_drawer.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<HomePageProvider>().currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer(
      builder: (context, UserProvider _2, child) => Consumer(
          builder: (context, HomePageProvider _, child) => Scaffold(
                key: _scaffoldKey,
                drawer: MainDrawer(),
                appBar: AppBarWidget.getAppBar("Zodyak Yıldızı",
                    isAction: true,
                    action: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(49, 54, 63, 0.9),
                            Color.fromRGBO(49, 54, 63, 0.8),
                            Color.fromRGBO(49, 54, 63, 0.7)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerRight,
                      height: 40,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          15.w,
                          Expanded(
                            child: Text(
                              "${_2.userModel!.gem}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          10.w,
                          Icon(
                            FontAwesomeIcons.gem,
                            size: 20,
                            color: Colors.blue[400],
                          ),
                          10.w,
                        ],
                      ),
                    ),
                    leading: IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        icon: Icon(
                          Icons.menu_open_rounded,
                        ))),
                body: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _.pageController,
                  children: [
                    MainPage(),
                    Expressions(),
                    Container(),
                  ],
                ),
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
                    items: MenuItems.bottomMenuList,
                  ).paddingAll(10),
                ).paddingAll(10),
              )),
    ));
  }
}
