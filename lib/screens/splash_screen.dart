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
      duration: Duration(milliseconds: 1500),
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
          Get.to(() => ExpertHome());
        });
      } else {
        _controller!.forward().whenComplete(() {
          Get.to(() => HomePage());
        });
      }
    } else {
      _controller!.forward().whenComplete(() {
        Get.to(() => LoginPage());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) {
            return Opacity(
              opacity: _controller!.value,
              child: Container(
                width: 200 * _controller!.value,
                height: 200 * _controller!.value,
                child: Image.asset('assets/splash.png'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
