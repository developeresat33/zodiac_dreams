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
  final String? request_uid;
  final String? user_uid;
  final String? user_name;
  final String? dreamComment;
  final bool? hasQuestion;
  final String? answer;
  final String? question;
  final String? questionAnswer;

  const ExpertSend({
    super.key,
    required this.user_uid,
    required this.user_name,
    required this.dreamComment,
    required this.request_uid,
    this.hasQuestion,
    this.question,
    this.answer,
    this.questionAnswer,
  });

  @override
  State<ExpertSend> createState() => _ExpertSendState();
}

class _ExpertSendState extends State<ExpertSend> {
  final TextEditingController _requestController = TextEditingController();
  bool? hasSentRequest;
  String userRequest = '';
  var proprop = Provider.of<ProcessProvider>(Get.context!, listen: false);
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    if (widget.hasQuestion!) {
      hasSentRequest = true;
    } else {
      hasSentRequest = false;
    }

    proprop.requestModel = RequestModel(
        sender_uid: widget.user_uid,
        receive_uid: userprop.userModel!.uid,
        senderName: widget.user_name,
        request_uid: widget.request_uid,
        question: widget.question ?? "");
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
                    20.h,
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Talep : " + widget.dreamComment!,
                          style: TextStyle(fontSize: 16),
                        ))
                      ],
                    ),
                    if (widget.answer != null && widget.answer != "")
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.h,
                            Row(
                              children: [Text("Yanıtınız : ")],
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
                                widget.answer!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (widget.question != null &&
                                widget.question != "")
                              Column(
                                children: [
                                  10.h,
                                ],
                              ),
                            Row(
                              children: [Text("Kullanıcının Sorusu : ")],
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
                                widget.question!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            10.h,
                            if (widget.questionAnswer != null &&
                                widget.questionAnswer != "")
                              Column(
                                children: [
                                  10.h,
                                  Row(
                                    children: [Text("Sorunun Yanıtı : ")],
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
                                      widget.questionAnswer!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    if (!hasSentRequest!) ...[
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: ZodiacTextField(
                              controller: _requestController,
                              hintText: "Yorumu yazınız",
                            ),
                          ),
                          10.w,
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              if (_requestController.text.isNotEmpty) {
                                await _.replyRequest(
                                  _requestController.text,
                                );
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
                      if (userRequest!="")
                        Expanded(
                          child: ListView(
                            children: [
                              10.h,
                              Text(
                                "Gönderdiğiniz Rüya Yorumu:",
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
                      Column(
                        children: [
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
                      ),
                    ],
                  ],
                ),
              ),
            ));
  }
}
