import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/states/process_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class ExpertSend extends StatefulWidget {
  final int? request_id;
  final String? user_name;
  final String? user_nick;
  final String? dreamComment;

  const ExpertSend(
      {super.key,
      this.request_id,
      this.user_name,
      this.dreamComment,
      this.user_nick});

  @override
  State<ExpertSend> createState() => _ExpertSendState();
}

class _ExpertSendState extends State<ExpertSend> {
  final TextEditingController _requestController = TextEditingController();
  bool hasSentRequest = false;
  String userRequest = '';
  var proprop = Provider.of<ProcessProvider>(Get.context!, listen: false);
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);

  @override
  void initState() {
    proprop.requestModel = RequestModel(
      sender: widget.user_nick,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ProcessProvider _, child) => Scaffold(
              appBar: AppBarWidget.getAppBar("Rüyayı Yorumla"),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: ListView(
                          children: [
                            10.h,
                            Row(
                              children: [
                                Expanded(child: Text(widget.dreamComment!))
                              ],
                            ),
                          ],
                        )),
                    20.h,
                    if (!hasSentRequest) ...[
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ZodiacTextField(
                              controller: _requestController,
                              maxLines: null,
                              hintText: "Rüyanızı yazınız",
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              if (_requestController.text.isNotEmpty) {
                                await _.replyRequest(_requestController.text,
                                    widget.request_id!);
                                setState(() {
                                  userRequest = _requestController.text;
                                  hasSentRequest = true;
                                });
                              } else {
                                GetMsg.showMsg("Lütfen boş bırakmayınız",
                                    option: 0);
                              }
                            },
                          ),
                        ],
                      ),
                      10.h,
                    ] else ...[
                      Expanded(
                        child: ListView(
                          children: [
                            Text(
                              "Gönderdiğiniz Rüya Yorumu:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              userRequest,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Yorumunuz tamamlandı.",
                              )),
                          5.w,
                          Expanded(
                              child: ZodiacButton(
                                  size: Size(70, 30),
                                  onPressed: () => Get.back(),
                                  child: Text("Tamam")))
                        ],
                      ),
                      10.h,
                    ],
                  ],
                ),
              ),
            ));
  }
}
