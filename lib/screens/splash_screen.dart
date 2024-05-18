import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zodiac_dreams/screens/home_page.dart';
import 'package:zodiac_dreams/screens/select_horoscope.dart';
import 'package:zodiac_dreams/services/storage_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  String? horoscope;

  @override
  void initState() {
    super.initState();
    horoscope = StorageManager.getString('horoscope');
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _controller!.forward().whenComplete(() {
      if (horoscope != '') {
        print(horoscope);
        Get.to(() => HomePage());
      } else {
        Get.to(() => SelectHoroscope());
      }
    });
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
