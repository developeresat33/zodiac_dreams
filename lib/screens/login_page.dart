import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/screens/register_page.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer(
            builder: (context, UserProvider _, child) => Scaffold(
                resizeToAvoidBottomInset: true,
                body: Column(children: [
                  25.h,
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 190,
                              width: 190,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(42, 48, 70, 1),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100))),
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                height: 130,
                                width: 130,
                                child: Image.asset(
                                  "assets/splash.png",
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  10.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Lütfen kullanıcı bilgilerinizi doğru giriniz.",
                        maxLines: 3,
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.4,
                    color: Colors.blue,
                  ),
                  10.h,
                  Expanded(
                      flex: 3,
                      child: Container(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(
                                        hintText: "Kullanıcı Adı"))
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacTextField(hintText: "Şifre"))
                              ],
                            ),
                            8.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Şifrenizi mi unuttunuz?",
                                    style: TextStyle(color: Colors.blue[400]),
                                  ),
                                )
                              ],
                            ),
                            10.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacButton(
                                  onPressed: () async {
                                    /*                   if (_formKey.currentState!.validate()) {
                                      _.saveUser();
                                    } else {
                                      GetMsg.showMsg(
                                          "Zorunlu alanları doldurunuz.",
                                          option: 0);
                                    } */
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Giriş Yap"),
                                      Icon(Icons.keyboard_arrow_right_outlined)
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            5.h,
                            Row(
                              children: [
                                Expanded(
                                    child: ZodiacButton(
                                  backgroundColor: Colors.blueGrey,
                                  onPressed: () async {
                                    Get.to(() => RegisterPage());
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Kayıt Ol"),
                                      Icon(Icons.person_outline_sharp)
                                    ],
                                  ),
                                ))
                              ],
                            ),
                            15.h,
                          ],
                        ),
                      )))
                ]).paddingSymmetric(horizontal: 20))));
  }
}
