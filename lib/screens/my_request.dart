import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/screens/request_detail.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _, child) => SafeArea(
              child: Scaffold(
                appBar: AppBarWidget.getAppBar("Taleplerim"),
                body: Column(
                  children: [
                    10.h,
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_.userModel!.uid)
                            .collection(FirebaseConstant.dreamRequestCollection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: getLoading());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Hata: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('Talep bulunamadı.'));
                          } else {
                            var myRequests = snapshot.data!.docs;
                            return ListView.builder(
                              itemCount: myRequests.length,
                              itemBuilder: (context, index) {
                                var request = myRequests[index];
                                print(Functions.formatTimestamp(
                                    request['created_at']));
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(30, 33, 37, 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                      "Gönderilen Yorumcu :  ${request['receiveName']}",
                                    ).paddingOnly(bottom: 5),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                request['comment'] ?? '',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.h,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              Functions.formatTimestamp(
                                                  request['created_at']),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        10.h,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  request['isFinish']
                                                      ? Icons.check_circle
                                                      : Icons
                                                          .watch_later_outlined,
                                                  color: request['isFinish']
                                                      ? Colors.green
                                                      : Colors.white,
                                                ),
                                                10.w,
                                                Text(
                                                  request['isFinish']
                                                      ? "Tamamlandı"
                                                      : "Yorum bekleniyor",
                                                ),
                                              ],
                                            ),
                                            ZodiacButton(
                                              size: Size(100, 40),
                                              onPressed: () =>
                                                  Get.to(() => RequestDetail(
                                                        question:
                                                            request['comment'],
                                                        answer:
                                                            request['reply'],
                                                      )),
                                              child: Text("Detay"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
              ),
            ));
  }
}
