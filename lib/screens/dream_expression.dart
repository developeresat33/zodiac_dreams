/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/data/dream.dart';
import 'package:zodiac_star/states/expression_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class DreamExpression extends StatefulWidget {
  final String title;
  const DreamExpression({super.key, required this.title});

  @override
  State<DreamExpression> createState() => _DreamExpressionState();
}

class _DreamExpressionState extends State<DreamExpression> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ExpressionProvider _, child) => SafeArea(
                child: Scaffold(
              appBar: AppBarWidget.getAppBar("Rüya İçeriği"),
              body: Column(
                children: [
                  10.h,
                  Expanded(
                      child: FutureBuilder<Dream>(
                    future: _.getDreamByTitle(widget.title),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: getLoading());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Hata: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('Rüya içeriği bulunamadı.'));
                      } else {
                        Dream dream = snapshot.data!;
                        return ListView.builder(
                          itemCount: dream.subtitles.length,
                          itemBuilder: (context, index) {
                            Subtitle subtitle = dream.subtitles[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subtitle.subtitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ...subtitle.description.map((desc) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(desc),
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ))
                ],
              ).paddingSymmetric(horizontal: 10),
            )));
  }
}
 */