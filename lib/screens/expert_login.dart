import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class LoginExpert extends StatefulWidget {
  const LoginExpert({super.key});

  @override
  State<LoginExpert> createState() => _LoginExpertState();
}

class _LoginExpertState extends State<LoginExpert> {
  final _formKey = GlobalKey<FormState>();
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    userprop.expertNickCt = TextEditingController();
    userprop.expertPasswordCt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer(
            builder: (context, UserProvider _, child) => Scaffold(
                appBar: AppBarWidget.getAppBar("Yorumcu Giriş Paneli"),
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      10.h,
                      Row(
                        children: [
                          Expanded(
                              child: ZodiacTextField(
                            controller: _.expertNickCt,
                            hintText: "Yorumcu Kullanıcı Adı",
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "*Zorunlu Alan";
                              }
                              return null;
                            },
                          ))
                        ],
                      ),
                      10.h,
                      Row(
                        children: [
                          Expanded(
                              child: ZodiacTextField(
                            controller: _.expertPasswordCt,
                            hintText: "Yorumcu Şifre",
                            obscureText: true,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "*Zorunlu Alan";
                              }
                              return null;
                            },
                          ))
                        ],
                      ),
                      10.h,
                      Row(children: [
                        Expanded(
                            child: ZodiacButton(
                                child: Text(
                                  "Giriş Yap",
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _.loginExpert();
                                  } else {
                                    GetMsg.showMsg(
                                        "Zorunlu Alanları Doldurunuz",
                                        option: 0);
                                  }
                                }))
                      ])
                    ]).paddingSymmetric(horizontal: 20),
                  ),
                ))));
  }
}
