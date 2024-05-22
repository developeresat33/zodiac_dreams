import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/common_widgets/zodiac_button.dart';
import 'package:zodiac_star/common_widgets/zodiac_textfield.dart';
import 'package:zodiac_star/main.dart';
import 'package:zodiac_star/screens/register_page.dart';
import 'package:zodiac_star/services/firebase_message.dart';
import 'package:zodiac_star/services/notification_permission.dart';
import 'package:zodiac_star/services/storage_manager.dart';
import 'package:zodiac_star/states/user_provider.dart';
import 'package:zodiac_star/utils/int_extension.dart';
import 'package:zodiac_star/widgets/ui/show_msg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    await Firebase.initializeApp();
    await CheckNotificationPermission.instance.checkPermission();
    messaging = FirebaseMessaging.instance;
    await FirebaseMessagingHelper.initFirebaseMessaging();
    userprop.rememberMe = StorageManager.getBool("remind");

    if (userprop.rememberMe == true) {
      userprop.rememberMe = true;
      try {
        initLogin();
      } catch (e) {
        print(e);
      }
    } else {
      userprop.rememberMe = false;
    }
  }

  initLogin() async {
    userprop.nickCt?.text = StorageManager.getString("id");
    userprop.passwordCt?.text = StorageManager.getString("pw");
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer(
            builder: (context, UserProvider _, child) => Scaffold(
                resizeToAvoidBottomInset: true,
                body: Stack(
                  children: [
                    Column(
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
                    Column(children: [
                      Spacer(
                        flex: 2,
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
                        thickness: 0.2,
                        color: Colors.blue,
                      ),
                      10.h,
                      Expanded(
                          flex: 3,
                          child: Container(
                              child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  10.h,
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ZodiacTextField(
                                        controller: _.nickCt,
                                        hintText: "Kullanıcı Adı",
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
                                        controller: _.passwordCt,
                                        obscureText: true,
                                        hintText: "Şifre",
                                        validator: (p0) {
                                          if (p0!.isEmpty) {
                                            return "*Zorunlu Alan";
                                          }
                                          return null;
                                        },
                                        onEditingComplete: () => doLogin(_),
                                      ))
                                    ],
                                  ),
                                  8.h,
                                  Row(
                                    children: [
                                      Expanded(
                                          child: CheckboxListTile(
                                        title: Text("Beni Hatırla"),
                                        value: _.rememberMe,
                                        onChanged: (value) =>
                                            _.setRemindMe(value),
                                      )),
                                    ],
                                  ),
                                  5.h,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Şifrenizi mi unuttunuz?",
                                            style: TextStyle(
                                                color: Colors.blue[400]),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  10.h,
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ZodiacButton(
                                        onPressed: () => doLogin(_),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Giriş Yap"),
                                            Icon(Icons
                                                .keyboard_arrow_right_outlined)
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                  10.h,
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ZodiacButton(
                                        backgroundColor:
                                            Color.fromRGBO(30, 33, 37, 1),
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
                            ),
                          )))
                    ]).paddingSymmetric(horizontal: 20),
                  ],
                ))));
  }

  void doLogin(UserProvider _) {
    if (_formKey.currentState!.validate()) {
      StorageManager.setBool("isRemind", _.rememberMe!);
      _.loginUser();
    } else {
      GetMsg.showMsg("Zorunlu alanları doldurunuz.", option: 0);
    }
  }
}
