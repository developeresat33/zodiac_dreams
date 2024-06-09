import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/screens/send_request.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class ExpressionComment extends StatefulWidget {
  const ExpressionComment({super.key});

  @override
  State<ExpressionComment> createState() => _ExpressionCommentState();
}

class _ExpressionCommentState extends State<ExpressionComment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.h,
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('expert_user')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: getLoading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Yorumcu bulunamadı.'));
                } else {
                  var experts = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: experts.length,
                    itemBuilder: (context, index) {
                      var expert = experts[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(30, 33, 37, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 75,
                              width: 75,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 75,
                                    width: 75,
                                    child: Center(
                                      child: Icon(Icons.person_search_sharp),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          expert['img_url'],
                                          fit: BoxFit.scaleDown,
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : Center(child: getLoading()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text(
                                    expert['expert_name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    expert['expert_desp'] ?? '',
                                    maxLines: 8,
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
                                        color: expert['avaible']
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                      SizedBox(width: 15),
                                      Text(
                                        expert['avaible']
                                            ? "Yorumlamaya hazır"
                                            : "Meşgul",
                                        style: TextStyle(
                                          color: expert['avaible']
                                              ? Colors.green
                                              : Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            Functions.screenSize.height * 0.030,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: RatingBar.builder(
                                            initialRating:
                                                expert['rate']?.toDouble() ??
                                                    0.0,
                                            minRating: 1,
                                            ignoreGestures: true,
                                            allowHalfRating: true,
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.orangeAccent,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                            tapOnlyMode: true,
                                          ),
                                        ),
                                      ),
                                      if (expert['avaible'])
                                        ZodiacButton(
                                          size: Size(100, 40),
                                          onPressed: () {
                                            Get.to(() => SendRequest(
                                                  master_uid: expert['uid'],
                                                  master_name:
                                                      expert['expert_name'],
                                       /*            master_nick:
                                                      expert['expert_username'], */
                                                ));
                                          },
                                          child: Text("Başlat"),
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).paddingOnly(bottom: 10);
                    },
                  );
                }
              },
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
