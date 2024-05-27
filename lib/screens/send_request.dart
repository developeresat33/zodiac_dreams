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

class SendRequest extends StatefulWidget {
  final String? master_uid;
  final String? master_nick;
  final String? master_name;

  const SendRequest(
      {super.key, this.master_nick, this.master_name, this.master_uid});

  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  final TextEditingController _requestController = TextEditingController();
  bool hasSentRequest = false;
  String userRequest = '';
  var proprop = Provider.of<ProcessProvider>(Get.context!, listen: false);
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);

  @override
  void initState() {
    print("USER UID" + userprop.userModel!.uid.toString());
    _init();
    super.initState();
  }

  _init() {
    proprop.requestModel = RequestModel(
      sender_uid: userprop.userModel!.uid,
      receive_uid: widget.master_uid,
      receiveName: widget.master_name,
      senderName: userprop.userModel!.nameSurname,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ProcessProvider _, child) => Scaffold(
              appBar: AppBarWidget.getAppBar("Rüya Yorumu"),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    10.h,
                    if (!hasSentRequest)
                      Column(
                        children: [
                          Text(
                            "Lütfen rüyanızı anlaşılabilir bir biçimde tek seferde yazınız. Talep tek seferde oluşturulup mevcut taleplerim sayfanıza düşecektir. Uzman yorumcu yorumladıktan hemen sonra taleplerim sayfanızda ilgili talebinizden yorumu görüntüleyebilirsiniz.",
                            style: TextStyle(color: Colors.white70),
                          ),
                          10.h,
                        ],
                      ),
                    if (!hasSentRequest) ...[
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ZodiacTextField(
                              controller: _requestController,
                              hintText: "Rüyanızı yazınız",
                            ),
                          ),
                          10.w,
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              if (_requestController.text.isNotEmpty) {
                                await _.addRequest(
                                  _requestController.text,
                                );
                                setState(() {
                                  userRequest = _requestController.text;
                                  hasSentRequest = true;
                                });
                              } else {
                                GetMsg.showMsg("Lütfen rüyanızı yazınız",
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
                              "Gönderdiğiniz Rüya Talebi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            10.h,
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(30, 33, 37, 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                userRequest,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
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
                                "Taleplerim sayfasından kontrol edebilirsiniz.",
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
