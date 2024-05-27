import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zodiac_star/data/user_model.dart';
import 'package:zodiac_star/dbHelper/auth.dart';
import 'package:zodiac_star/screens/expert_home.dart';
import 'package:zodiac_star/screens/home_page.dart';
import 'package:zodiac_star/screens/login_page.dart';
import 'package:zodiac_star/states/user_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  FirebaseAuthService authService = FirebaseAuthService();

  var userprop = Provider.of<UserProvider>(Get.context!, listen: false);
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _autoLogin();
  }

  _autoLogin() async {
    authService.user = await FirebaseAuth.instance.currentUser;

    await Future.delayed(Duration(milliseconds: 100));
    if (authService.user != null) {
      userprop.userModel = UserModel();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authService.user!.uid)
          .get();
      userprop.userModel = UserModel.parseRegisterModelFromDocument(
          userDoc.data() as Map<String, dynamic>);

      if (userprop.userModel!.isExpert) {
        _controller!.forward().whenComplete(() {
          Get.offAll(() => ExpertHome());
        });
      } else {
        _controller!.forward().whenComplete(() {
          Get.offAll(() => HomePage());
        });
      }
    } else {
      _controller!.forward().whenComplete(() {
        Get.offAll(() => LoginPage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Align(
              alignment: Alignment(1 - (_controller!.value), 0),
              child: Opacity(
                  opacity: _controller!.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(
                      'assets/splash.png',
                      fit: BoxFit.scaleDown,
                    ),
                  )));
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
