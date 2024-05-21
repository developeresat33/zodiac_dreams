import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/data/mini_items.dart';
import 'package:zodiac_star/screens/dream_expression.dart';
import 'package:zodiac_star/states/expression_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class Expressions extends StatefulWidget {
  const Expressions({super.key});

  @override
  State<Expressions> createState() => _ExpressionsState();
}

class _ExpressionsState extends State<Expressions> {
  @override
  void initState() {
    context.read<ExpressionProvider>().currentIndex = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ExpressionProvider _, child) => Scaffold(
              body: Column(
                children: [
                  5.h,
                  SizedBox(
                    height: Functions.screenSize.height * 0.1,
                    width: double.maxFinite,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: MiniItems.alphabet.length,
                      itemBuilder: (context, index) {
                        return ChoiceChip(
                          onSelected: (value) => _.changeIndex(index),
                          selectedColor: Colors.blue[800],
                          label: Text(MiniItems.alphabet[index]),
                          selected: index == _.currentIndex,
                        ).paddingOnly(right: 5);
                      },
                    ),
                  ),
                  10.h,
                  Expanded(
                      child: FutureBuilder<List<String>>(
                    future:
                        _.getDreamTitles(MiniItems.alphabet[_.currentIndex]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: getLoading());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Hata: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Veri bulunamadı.'));
                      } else {
                        List<String> titles = snapshot.data ?? [];

                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: titles.length,
                          itemBuilder: (context, index) {
                            return CardTile(
                              onTap: () {
                                Get.to(() =>
                                    DreamExpression(title: titles[index]));
                              },
                              backgroundColor: Color.fromRGBO(30, 33, 37, 1),
                              leading: Icons.star_outline_outlined,
                              title: titles[index],
                              trailing: Icons.chevron_right,
                            ).paddingOnly(bottom: 10);
                          },
                        );
                      }
                    },
                  ))
                ],
              ).paddingSymmetric(horizontal: 10),
            ));
  }
}
