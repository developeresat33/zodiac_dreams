import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/data/request_model.dart';
import 'package:zodiac_star/states/process_provider.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

// ignore: must_be_immutable
class RequestDetail extends StatefulWidget {
  final String? question;
  final String? answer;
  final bool? rightQuestion;
  String? askedQuestion;
  final String? replyQuestion;
  final String? master_uid;
  final String? master_name;
  final String? request_uid;

  RequestDetail({
    super.key,
    this.question,
    this.answer,
    this.rightQuestion,
    this.askedQuestion,
    this.replyQuestion,
    this.master_uid,
    this.master_name,
    this.request_uid,
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
          appBar: AppBarWidget.getAppBar(" Rüya Detayı"),
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
                          'Sorulan Soru:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.h,
                        Text(
                          widget.question ?? 'Sorulan soru bulunamadı.',
                          style: TextStyle(fontSize: 16),
                        ),
                        10.h,
                        Text(
                          'Uzmanın Yanıtı:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.h,
                        Text(
                          widget.answer != "" && widget.answer != null
                              ? widget.answer!
                              : 'Yanıt Bekleniyor..',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (widget.askedQuestion != null &&
                            widget.askedQuestion != "")
                          Column(
                            children: [
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    'Sorduğunuz Soru:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    widget.askedQuestion ??
                                        'Sorulan soru bulunamadı.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (widget.askedQuestion != null &&
                            widget.askedQuestion != "")
                          Column(
                            children: [
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    'Sorunuzun Cevabı:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              10.h,
                              Row(
                                children: [
                                  Text(
                                    widget.replyQuestion != "" &&
                                            widget.replyQuestion != null
                                        ? widget.replyQuestion!
                                        : 'Yanıt Bekleniyor..',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.answer != "" &&
                    widget.answer != null &&
                    widget.rightQuestion == false &&
                    widget.askedQuestion == null)
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
          ),
        ),
      ),
    );
  }
}
