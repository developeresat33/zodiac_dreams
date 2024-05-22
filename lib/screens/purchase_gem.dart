import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/data/mini_items.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/gem_widget.dart';

class PurchaseGem extends StatefulWidget {
  const PurchaseGem({super.key});

  @override
  State<PurchaseGem> createState() => _PurchaseGemState();
}

class _PurchaseGemState extends State<PurchaseGem> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _2, child) => SafeArea(
              child: Scaffold(
                appBar: AppBarWidget.getAppBar("Elmas Satın Al",
                    isAction: true,
                    action: GemWidget(
                      data: _2.userModel!.gem,
                    )),
                body: Column(
                  children: [
                    15.h,
                    Expanded(
                      child: ListView.builder(
                        itemCount: MiniItems.packageItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(30, 33, 37, 1),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                5.h,
                                Row(
                                  children: [
                                    Icon(
                                      MiniItems.packageItems[index].icon,
                                      color: Colors.white,
                                    ),
                                    5.w,
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          MiniItems
                                              .packageItems[index].packageName!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Expanded(
                                        child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(Functions.formatterPrice
                                          .format(num.parse(MiniItems
                                              .packageItems[index]
                                              .packagePrice!))),
                                    ))
                                  ],
                                ),
                                15.h,
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(MiniItems
                                            .packageItems[index]
                                            .packageDescription!))
                                  ],
                                ),
                                20.h,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ZodiacButton(
                                        size: Size(200, 40),
                                        onPressed: () {},
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            children: [
                                              Icon(Icons.shopping_bag_outlined),
                                              10.w,
                                              Text("Satın Al"),
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ).paddingOnly(bottom: 10);
                        },
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            ));
  }
}
