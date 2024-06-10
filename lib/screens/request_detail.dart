import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
class RequestDetail extends StatefulWidget {
  final String? question;
  final String? answer;
  bool? rightQuestion;
  String? askedQuestion;
  final String? replyQuestion;
  final String? master_uid;
  final String? master_name;
  final String? request_uid;
  final double? rate;
  final bool? isRated;

  RequestDetail({
    super.key,
    this.question,
    this.isRated,
    this.answer,
    this.rightQuestion,
    this.askedQuestion,
    this.replyQuestion,
    this.master_uid,
    this.master_name,
    this.request_uid,
    this.rate,
  });

  @override
  State<RequestDetail> createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  TextEditingController _questionController = TextEditingController();
  var proprop = Provider.of<ProcessProvider>(Get.context!, listen: false);
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
  bool hasSentRequest = false;
  String userRequest = '';
  bool isRating = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  _init() {
    isRating = widget.isRated!;
    proprop.requestModel = RequestModel(
      sender_uid: userprop.userModel!.uid,
      receive_uid: widget.master_uid,
      receiveName: widget.master_name,
      senderName: userprop.userModel!.nameSurname,
      request_uid: widget.request_uid,
    );
  }

  Future<void> _handleSendQuestion(ProcessProvider provider) async {
    String newQuestion = _questionController.text;

    if (newQuestion.isNotEmpty) {
      try {
        await provider.askQuestion(
          newQuestion,
        );
        setState(() {
          widget.rightQuestion = true;
          widget.askedQuestion = newQuestion;
          _questionController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProcessProvider>(
      builder: (context, _, child) => SafeArea(
        child: Scaffold(
          appBar: AppBarWidget.getAppBar(" Rüya Detayı",
              isAction: true,
              action: widget.replyQuestion != null &&
                      widget.replyQuestion != "" &&
                      widget.answer != "" &&
                      widget.answer != null
                  ? TextButton(
                      onPressed: () => Functions.showYesNoDialog(
                          () => _.removeRequest(false)),
                      child: Text("Kaldır"))
                  : SizedBox(
                      height: 10,
                      width: 10,
                    )),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Talebiniz:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
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
                        10.h,
                        Text(
                          'Uzmanın Yanıtı:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        10.h,
                        Container(
                          decoration: getDecoration(),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.answer != "" && widget.answer != null
                                ? widget.answer!
                                : 'Yanıt Bekleniyor..',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (widget.askedQuestion != null &&
                            widget.askedQuestion != "")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    'Sorduğunuz Soru:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Container(
                                decoration: getDecoration(),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  widget.askedQuestion ??
                                      'Sorulan soru bulunamadı.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (widget.askedQuestion != null &&
                            widget.askedQuestion != "")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    'Sorunuzun Cevabı:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Container(
                                decoration: getDecoration(),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  widget.replyQuestion != "" &&
                                          widget.replyQuestion != null
                                      ? widget.replyQuestion!
                                      : 'Yanıt Bekleniyor..',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (widget.replyQuestion != null &&
                            widget.replyQuestion != "" &&
                            widget.answer != "" &&
                            widget.answer != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    widget.rate != null && widget.rate != 0.0
                                        ? "Verdiğiniz Puan : " +
                                            widget.rate.toString()
                                        : "Yorumu değerlendirmek ister misiniz?",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              15.h,
                              SizedBox(
                                height: Functions.screenSize.height * 0.030,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: RatingBar.builder(
                                    initialRating: widget.rate ?? 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    ignoreGestures: isRating,
                                    allowHalfRating: true,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.orangeAccent,
                                    ),
                                    onRatingUpdate: (rating) async {
                                      await _.voteRequest(rating);
                                      setState(() {
                                        isRating = true;
                                      });
                                      GetMsg.showMsg(
                                          "Puanlamanız gönderildi, Teşekkür ederiz.",
                                          option: 1);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
                if (widget.answer != "" &&
                    widget.answer != null &&
                    widget.rightQuestion == false)
                  Column(
                    children: [
                      Row(
                        children: [Text("Soru sorma hakkınız var")],
                      ),
                      10.h,
                      Row(
                        children: [
                          Expanded(
                            child: ZodiacTextField(
                              controller: _questionController,
                              hintText: "Sorunuzu yazınız",
                            ),
                          ),
                          10.w,
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              if (_questionController.text.isNotEmpty) {
                                await _handleSendQuestion(_);
                                setState(() {
                                  userRequest = _questionController.text;
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
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
