import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/screens/expert_login.dart';
import 'package:zodiac_star/screens/expert_send.dart';
import 'package:zodiac_star/states/process_provider.dart';
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
  late Future<List<Map<String, dynamic>>> _myRequestFuture;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    _myRequestFuture = context.read<ProcessProvider>().getExpertRequest();
  }

  Future<void> _refreshRequests() async {
    await _loadRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              child: RefreshIndicator(
                onRefresh: _refreshRequests,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _myRequestFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: getLoading());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Talep mevcut değil.'));
                    } else {
                      var myRequests = snapshot.data!;
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
                              title: Text("Gönderen Kişi ${request['sender']}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['comment'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ZodiacButton(
                                        size: Size(100, 40),
                                        onPressed: () => Get.to(() =>
                                            ExpertSend(
                                              request_id: request['request_id'],
                                              user_name: request['senderName'],
                                              user_nick: request['sender'],
                                              dreamComment: request['comment'],
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
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}
