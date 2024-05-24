import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/dbHelper/firebase.dart';
import 'package:zodiac_star/screens/expert_login.dart';
import 'package:zodiac_star/screens/expert_send.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/loading.dart';
import '../common_widgets/zodiac_button.dart';

class ExpertHome extends StatefulWidget {
  const ExpertHome({super.key});

  @override
  State<ExpertHome> createState() => _ExpertHomeState();
}

class _ExpertHomeState extends State<ExpertHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, UserProvider _, child) => SafeArea(
              child: Scaffold(
                appBar: AppBarWidget.getAppBar(
                  "Yorumcu Anasayfa",
                  leading: IconButton(
                    onPressed: () {
                      Get.offAll(() => LoginExpert());
                    },
                    icon: Icon(Icons.menu_open_rounded),
                  ),
                ),
                body: Column(
                  children: [
                    10.h,
                    Row(
                      children: [Expanded(child: Text("Bekleyen talepler"))],
                    ),
                    10.h,
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('expert_account')
                            .doc(_.expertModel!.uid)
                            .collection(FirebaseConstant.dreamRequestCollection)
                            .where('isFinish', isEqualTo: false)
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
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(30, 33, 37, 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    title: Text(
                                        "Gönderen Kişi ${request['sender']}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          request['comment'] ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ZodiacButton(
                                              size: Size(100, 40),
                                              onPressed: () => Get.to(() =>
                                                  ExpertSend(
                                                    request_uid:
                                                        request['request_uid'],
                                                    user_uid:
                                                        request['sender_uid'],
                                                    user_name:
                                                        request['senderName'],
                                                    user_nick:
                                                        request['sender'],
                                                    dreamComment:
                                                        request['comment'],
                                                  )),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Cevapla"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
            ));
  }
}
