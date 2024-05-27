import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dialogs/user_dialog.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/app_bar.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().registerController!.init();
    context.read<UserProvider>().registerModel = UserModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
          builder: (context, UserProvider _, child) => Scaffold(
                appBar: AppBarWidget.getAppBar("Kayıt Ol"),
                resizeToAvoidBottomInset: true,
                body: Column(
                  children: [
                    15.h,
                    Expanded(
                      child: SingleChildScrollView(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            15.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                  controller: _.registerController!.nickCt,
                                  hintText: "Kullanıcı E-Posta",
                                  onChanged: (value) =>
                                      _.registerModel!.email = value,
                                  validator: (p0) {
                                    if (p0!.isEmpty) {
                                      return "*Zorunlu Alan";
                                    }
                                    // E-posta regex kontrolü
                                    final emailRegex = RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                    if (!emailRegex.hasMatch(p0)) {
                                      return "Geçerli bir e-posta giriniz";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      Get.focusScope!.nextFocus(),
                                ))
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                  controller:
                                      _.registerController!.nameSurnameCt,
                                  hintText: "Adınız Soyadınız",
                                  onChanged: (value) =>
                                      _.registerModel!.nameSurname = value,
                                  validator: (p0) {
                                    if (p0!.isEmpty) {
                                      return "*Zorunlu Alan";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      Get.focusScope!.nextFocus(),
                                ))
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                  controller: _.registerController!.ageCt,
                                  hintText: "Yaşınız",
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) =>
                                      _.registerModel!.age = value,
                                  validator: (p0) {
                                    if (p0!.isEmpty) {
                                      return "*Zorunlu Alan";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      Get.focusScope!.nextFocus(),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                ))
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                  controller: _.registerController!.horoscopeCt,
                                  readOnly: true,
                                  onTap: () {
                                    UserDialog.horoscopeModelBottomSheet();
                                  },
                                  hintText: "Burcunuzu Seçiniz",
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
                                  controller: _.registerController!.passwordCt,
                                  onChanged: (value) =>
                                      _.registerModel!.password = value,
                                  obscureText: true,
                                  hintText: "Şifre",
                                  validator: (p0) {
                                    if (p0!.isEmpty) {
                                      return "*Zorunlu Alan";
                                    }
                                    return null;
                                  },
                                  onEditingComplete: () =>
                                      Get.focusScope!.nextFocus(),
                                ))
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                  obscureText: true,
                                  controller:
                                      _.registerController!.confirmPasswordCt,
                                  hintText: "Şifre (Tekrar)",
                                  validator: (p0) {
                                    if (_.registerController!.passwordCt !=
                                            null &&
                                        _.registerController!
                                                .confirmPasswordCt !=
                                            null &&
                                        _.registerController!.passwordCt!
                                                .text !=
                                            _.registerController!
                                                .confirmPasswordCt!.text) {
                                      return "*Şifreler Uyuşmuyor";
                                    } else if (p0!.isEmpty) {
                                      return "*Zorunlu Alan";
                                    }
                                    return null;
                                  },
                                ))
                              ],
                            ),
                          ],
                        ),
                      )),
                    ),
                    30.h,
                    Row(
                      children: [
                        Expanded(
                            child: ZodiacButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _.saveUser();
                            } else {
                              GetMsg.showMsg("Zorunlu alanları doldurunuz.",
                                  option: 0);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Kaydı Tamamla"),
                              Icon(Icons.keyboard_arrow_right_outlined)
                            ],
                          ),
                        ))
                      ],
                    ),
                    10.h,
                  ],
                ).paddingSymmetric(horizontal: 20),
              )),
    );
  }
}
