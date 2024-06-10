import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/states/process_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/functions.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/box_const.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

// ignore: must_be_immutable
class ExpertSend extends StatefulWidget {
  final String? request_uid;
  final String? user_uid;
  final String? user_name;
  final String? dreamComment;
  final bool? hasQuestion;
  final bool? isFinish;
  final double? rate;
  final bool? isRating;
  String? answer;
  final String? question;
  String? questionAnswer;

  ExpertSend({
    super.key,
    required this.user_uid,
    required this.user_name,
    required this.dreamComment,
    required this.request_uid,
    this.hasQuestion,
    this.question,
    this.answer,
    this.questionAnswer,
    this.isFinish,
    this.rate,
    this.isRating,
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
              appBar: AppBarWidget.getAppBar("Rüyayı Yorumla",
                  isAction: true,
                  action: widget.questionAnswer != null &&
                          widget.questionAnswer != "" &&
                          widget.answer != "" &&
                          widget.answer != null
                      ? TextButton(
                          onPressed: () => Functions.showYesNoDialog(
                              () => _.removeRequest(true)),
                          child: Text("Kaldır"))
                      : SizedBox(
                          height: 10,
                          width: 10,
                        )),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.h,
                            Row(
                              children: [
                                Text(
                                  "Talep : ",
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            10.h,
                            Container(
                              decoration: getDecoration(),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                widget.dreamComment!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (widget.answer != null && widget.answer != "")
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.h,
                                  Row(
                                    children: [Text("Yanıtınız : ")],
                                  ),
                                  10.h,
                                  Container(
                                    decoration: getDecoration(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        10.h,
                                        Row(
                                          children: [
                                            Text("Kullanıcının Sorusu : ")
                                          ],
                                        ),
                                        10.h,
                                        Container(
                                          decoration: getDecoration(),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            widget.question!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  10.h,
                                  if (widget.questionAnswer != null &&
                                      widget.questionAnswer != "")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        10.h,
                                        Row(
                                          children: [Text("Sorunun Yanıtı : ")],
                                        ),
                                        10.h,
                                        Container(
                                          decoration: getDecoration(),
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
                          ],
                        ),
                      ),
                    ),
                    if ((widget.hasQuestion! &&
                            (widget.questionAnswer == null ||
                                widget.questionAnswer == "")) ||
                        (!widget.hasQuestion! &&
                            (widget.answer == null ||
                                widget.answer == ""))) ...[
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
                                if (widget.hasQuestion!) {
                                  await _.replyQuestion(
                                    _requestController.text,
                                  );

                                  setState(() {
                                    widget.questionAnswer =
                                        _requestController.text;
                                    hasSentRequest = true;
                                  });

                                  _requestController.clear();
                                } else {
                                  await _.replyRequest(
                                    _requestController.text,
                                  );
                                  setState(() {
                                    widget.answer = _requestController.text;
                                    hasSentRequest = true;
                                  });
                                  _requestController.clear();
                                }
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
                      if ((widget.hasQuestion! &&
                              (widget.questionAnswer != null ||
                                  widget.questionAnswer != "")) ||
                          (!widget.hasQuestion! &&
                              (widget.answer != null || widget.answer != "")))
                        widget.isFinish != null &&
                                !widget.isFinish! &&
                                !widget.hasQuestion!
                            ? Column(
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
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            widget.isRating == true
                                                ? "Aldığınız Puan : ${widget.rate}"
                                                : "Henüz Puanlanmadı",
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
