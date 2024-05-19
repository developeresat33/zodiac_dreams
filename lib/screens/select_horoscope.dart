import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/data/menu_items.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class SelectHoroscope extends StatefulWidget {
  const SelectHoroscope({super.key});

  @override
  State<SelectHoroscope> createState() => _SelectHoroscopeState();
}

class _SelectHoroscopeState extends State<SelectHoroscope> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _, child) => Scaffold(
          backgroundColor: Colors.transparent,
                body: Column(
              children: [
                15.h,
                Expanded(
                    child: AnimationLimiter(
                  child: GridView.builder(
                    itemCount: MenuItems.horoscopeList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                              child: GestureDetector(
                            onTap: () async {
                              Get.back();
                              _.registerModel!.horoscope =
                                  MenuItems.horoscopeList[index].name!;
                              _.registerController!.horoscopeCt!.text =
                                  MenuItems.horoscopeList[index].name!;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        MenuItems.horoscopeList[index].color!
                                            .withOpacity(0.9),
                                        MenuItems.horoscopeList[index].color!
                                            .withOpacity(0.8),
                                        MenuItems.horoscopeList[index].color!
                                            .withOpacity(0.7)
                                      ])),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 35,
                                        width: 35,
                                        child: Image.asset(
                                          MenuItems.horoscopeList[index].image!,
                                          fit: BoxFit.scaleDown,
                                          color: Colors.white,
                                        )),
                                    5.h,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          MenuItems.horoscopeList[index].name!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    10.h,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          MenuItems
                                              .horoscopeList[index].subtitle!,
                                          style: TextStyle(),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )));
                    },
                  ),
                )),
                15.h
              ],
            ).paddingSymmetric(horizontal: 20)));
  }
}
