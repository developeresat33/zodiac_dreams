/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/card_tile.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
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
  var exprop = Provider.of<ExpressionProvider>(Get.context!, listen: false);

  @override
  void initState() {
    context.read<ExpressionProvider>().currentIndex = 0;
    exprop.getDreamTitles("A");
    exprop.searchCt = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    exprop.searchCt!.dispose();
    super.dispose();
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
                          backgroundColor: Color.fromRGBO(34, 40, 49, 1),
                          onSelected: (value) => _.changeIndex(index),
                          selectedColor: Colors.blue[800],
                          label: Text(MiniItems.alphabet[index]),
                          selected: index == _.currentIndex,
                        ).paddingOnly(right: 5);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ZodiacTextField(
                        controller: _.searchCt,
                        hintText: "Ara",
                        prefixIcon: Icon(Icons.search),
                        onChanged: (value) => _.filterTitles(value),
                      ))
                    ],
                  ),
                  10.h,
                  _.isList!
                      ? _.allTitles != null && _.allTitles!.length > 0
                          ? Expanded(
                              child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _.filteredTitles!.length,
                              itemBuilder: (context, index) {
                                return CardTile(
                                  onTap: () {
                                    Get.to(() => DreamExpression(
                                        title: _.filteredTitles![index]));
                                  },
                                  backgroundColor:
                                      Color.fromRGBO(30, 33, 37, 1),
                                  leading: Icons.star_outline_outlined,
                                  title: _.filteredTitles![index],
                                  trailing: Icons.chevron_right,
                                ).paddingOnly(bottom: 10);
                              },
                            ))
                          : Expanded(
                              child: Center(child: Text("Rüya bulunamadı.")))
                      : Expanded(child: Center(child: getLoading())),
                ],
              ).paddingSymmetric(horizontal: 10),
            ));
  }
}
 */