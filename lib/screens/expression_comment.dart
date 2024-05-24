import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/screens/send_request.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class ExpressionComment extends StatefulWidget {
  const ExpressionComment({super.key});

  @override
  State<ExpressionComment> createState() => _ExpressionCommentState();
}

class _ExpressionCommentState extends State<ExpressionComment> {
  late Future<List<Map<String, dynamic>>> _expertsFuture;

  @override
  void initState() {
    _expertsFuture = getExpertsFromFirestore();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> getExpertsFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('expert_user').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          10.h,
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _expertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: getLoading());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Yorumcu bulunamadı.'));
                } else {
                  var experts = snapshot.data!;
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
                                  8.h,
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
                                        color: expert['avaible']
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                      15.w,
                                      Text(
                                        expert['avaible']
                                            ? "Yorumlamaya hazır"
                                            : "Yorumlamaya hazır değil",
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ZodiacButton(
                                        size: Size(100, 40),
                                        onPressed: () {
                                          Get.to(() => SendRequest(
                                                master_uid: expert['uid'],
                                                master_name:
                                                    expert['expert_name'],
                                                master_nick:
                                                    expert['expert_username'],
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
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
