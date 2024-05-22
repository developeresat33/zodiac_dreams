import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/screens/send_request.dart';
import 'package:zodiac_star/states/expression_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class ExpressionComment extends StatefulWidget {
  const ExpressionComment({super.key});

  @override
  State<ExpressionComment> createState() => _ExpressionCommentState();
}

class _ExpressionCommentState extends State<ExpressionComment> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ExpressionProvider _, child) => Scaffold(
              body: Column(
                children: [
                  10.h,
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _.getExperts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: getLoading());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Hata: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('Yorumcu bulunamadı.'));
                        } else {
                          var expert = snapshot.data!;
                          return ListView.builder(
                            itemCount: expert.length,
                            itemBuilder: (context, index) {
                              var expertName = expert[index];

                              return Container(
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(30, 33, 37, 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Resmi üstte hizalar
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(expertName['img_url']),
                                      radius: 30,
                                    ).paddingOnly(top: 5),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            expertName['expert_name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            expertName['expert_desp'] ?? '',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.stacked_bar_chart_sharp,
                                                color: expertName['avaible']
                                                    ? Colors.green
                                                    : Colors.redAccent,
                                              ),
                                              15.w,
                                              Text(
                                                expertName['avaible']
                                                    ? "Yorumlamaya hazır"
                                                    : "Yorumlamaya hazır değil",
                                                style: TextStyle(
                                                  color: expertName['avaible']
                                                      ? Colors.green
                                                      : Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ZodiacButton(
                                                  size: Size(100, 40),
                                                  onPressed: () {
                                                    Get.to(() => SendRequest(
                                                          master_name:
                                                              expertName[
                                                                  'expert_name'],
                                                          master_nick: expertName[
                                                              'expert_username'],
                                                        ));
                                                  },
                                                  child: Text("Başlat"))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
            ));
  }
}
